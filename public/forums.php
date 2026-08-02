<?php

require "../autoload.php";

$pages["isForums"] = true;

$view = clean($_GET["page"] ?? "forums"); // forums | forum | thread
$error = false;

// ===================== Создание категории форума (только is_forum_admin) =====================
if (isset($_POST["createForum"]) && $logged && $userlevel["perms"]["is_forum_admin"]) {
    $name = clean($_POST["name"] ?? "");
    $description = clean($_POST["description"] ?? "");

    if (empty($name)) {
        $error = true;
        $smarty->assign("error", "Forum name cannot be empty!");
    }

    if (containsXSS($name) || containsXSS($description)) {
        $error = true;
        doLog("createForum", false, "XSS detected", $user["_id"]);
        $smarty->assign("error", "Input contains invalid characters!");
    }

    if (!$error) {
        $forum = $db["forums"]->insert([
            "name" => $name,
            "description" => $description,
            "user_id" => $user["_id"],
            "timestamp" => now()
        ]);
        doLog("createForum", true, $forum["_id"], $user["_id"]);
        header("Refresh: 0");
        die("created");
    }
}

// ===================== Создание темы (только can_post_forum) =====================
if (isset($_POST["createThread"]) && $logged && $userlevel["perms"]["can_post_forum"]) {
    $forumId = (int) clean($_POST["forum_id"] ?? 0);
    $title = clean($_POST["title"] ?? "");
    $content = clean($_POST["content"] ?? "");

    $forum = $db["forums"]->findById($forumId);
    if (empty($forum)) {
        $error = true;
        $smarty->assign("error", "Forum does not exist!");
    }

    if (empty($title) || empty($content)) {
        $error = true;
        $smarty->assign("error", "Title and content cannot be empty!");
    }

    if (containsXSS($title) || containsXSS($content)) {
        $error = true;
        doLog("createThread", false, "XSS detected", $user["_id"]);
        $smarty->assign("error", "Input contains invalid characters!");
    }

    if (!$error) {
        $thread = $db["forumPosts"]->insert([
            "forum_id" => $forumId,
            "parent" => null,
            "title" => $title,
            "content" => $content,
            "user_id" => $user["_id"],
            "timestamp" => now()
        ]);
        doLog("createThread", true, $thread["_id"], $user["_id"]);
        header("Location: forums.php?page=thread&id=" . $thread["_id"]);
        die("created");
    }
}

// ===================== Ответ в теме (только can_reply_forum) =====================
if (isset($_POST["createReply"]) && $logged && $userlevel["perms"]["can_reply_forum"]) {
    $threadId = (int) clean($_POST["thread_id"] ?? 0);
    $content = clean($_POST["content"] ?? "");

    $thread = $db["forumPosts"]->findById($threadId);
    if (empty($thread) || !empty($thread["parent"])) {
        $error = true;
        $smarty->assign("error", "Thread does not exist!");
    }

    if (strlen($content) < $config["minlength"]["comment"]) {
        $error = true;
        $smarty->assign("error", "Reply not at least {$config["minlength"]["comment"]} characters long!");
    }

    if (containsXSS($content)) {
        $error = true;
        doLog("createReply", false, "XSS detected", $user["_id"]);
        $smarty->assign("error", "Input contains invalid characters!");
    }

    if (!$error) {
        $reply = $db["forumPosts"]->insert([
            "forum_id" => $thread["forum_id"],
            "parent" => $threadId,
            "title" => "",
            "content" => $content,
            "user_id" => $user["_id"],
            "timestamp" => now()
        ]);
        doLog("createReply", true, $reply["_id"], $user["_id"]);
        header("Refresh: 0");
        die("replied");
    }
}

// ===================== Отображение =====================
switch ($view) {
    case "forum":
        $forumId = (int) clean($_GET["id"] ?? 0);
        $forum = $db["forums"]->findById($forumId);
        if (empty($forum)) header("Location: forums.php") && die("forum not found.");

        $currentPage = max(1, (int) clean($_GET["pagination"] ?? 1));
        $perpage = 20;
        $skip = ($currentPage - 1) * $perpage;

        $threads = $db["forumPosts"]->createQueryBuilder()
            ->where([["forum_id", "==", $forumId], "AND", ["parent", "==", null]])
            ->orderBy(["timestamp" => "DESC"])
            ->skip($skip)
            ->limit($perpage)
            ->getQuery()
            ->fetch();

        foreach ($threads as $key => $thread) {
            $threads[$key]["user"] = $db["users"]->findById($thread["user_id"]);
            $threads[$key]["replyCount"] = count($db["forumPosts"]->findBy(["parent", "==", $thread["_id"]]));
        }

        $totalThreads = count($db["forumPosts"]->createQueryBuilder()
            ->where([["forum_id", "==", $forumId], "AND", ["parent", "==", null]])
            ->getQuery()
            ->fetch());

        $smarty->assign("forum", $forum);
        $smarty->assign("threads", $threads);
        $smarty->assign("currentPage", $currentPage);
        $smarty->assign("totalPages", max(1, ceil($totalThreads / $perpage)));
        $smarty->assign("pagetitle", $forum["name"]);
        $page = "forum";
        break;

    case "thread":
        $threadId = (int) clean($_GET["id"] ?? 0);
        $thread = $db["forumPosts"]->findById($threadId);
        if (empty($thread) || !empty($thread["parent"])) header("Location: forums.php") && die("thread not found.");

        $thread["user"] = $db["users"]->findById($thread["user_id"]);
        $forum = $db["forums"]->findById($thread["forum_id"]);

        $replies = $db["forumPosts"]->findBy(["parent", "==", $threadId], ["timestamp" => "ASC"]);
        foreach ($replies as $key => $reply) {
            $replies[$key]["user"] = $db["users"]->findById($reply["user_id"]);
        }

        $smarty->assign("forum", $forum);
        $smarty->assign("thread", $thread);
        $smarty->assign("replies", $replies);
        $smarty->assign("pagetitle", $thread["title"]);
        $page = "thread";
        break;

    default:
        $forums = $db["forums"]->findAll(["timestamp" => "ASC"]);
        foreach ($forums as $key => $forum) {
            $threadCount = count($db["forumPosts"]->findBy([["forum_id", "==", $forum["_id"]], "AND", ["parent", "==", null]]));
            $postCount = count($db["forumPosts"]->findBy(["forum_id", "==", $forum["_id"]]));
            $forums[$key]["threadCount"] = $threadCount;
            $forums[$key]["postCount"] = $postCount;
        }
        $smarty->assign("forums", $forums);
        $smarty->assign("pagetitle", $lang["forums"]);
        $page = "forums";
}

$smarty->assign("pages", $pages);

require "../endtime.php";

$smarty->display("part.top.tpl");
$smarty->display("page.forums.tpl");
$smarty->display("part.bottom.tpl");
