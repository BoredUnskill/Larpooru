<?php

require "../autoload.php";

$pages["isAdmin"] = true;
$error = false;

// ===================== Доступ только для модераторов/админов =====================
if (!$logged || !$userlevel["perms"]["can_manage_reports"]) {
    header("Location: index.php");
    die("Access denied.");
}

$tab = clean($_GET["tab"] ?? "home");

// ===================== Действия: очередь на одобрение =====================
if (isset($_POST["approvePost"])) {
    $id = (int) clean($_POST["approvePost"]);
    $post = $db["posts"]->findById($id);
    if (!empty($post)) {
        $db["posts"]->updateById($id, ["status" => "active", "statusReason" => null]);
        doLog("approvePost", true, $id, $user["_id"]);
    }
    header("Refresh: 0");
    die("approved");
}

if (isset($_POST["rejectPost"])) {
    $id = (int) clean($_POST["rejectPost"]);
    $reason = clean($_POST["reason"] ?? "Rejected by moderator");
    $post = $db["posts"]->findById($id);
    if (!empty($post)) {
        $db["posts"]->updateById($id, ["status" => "active", "deleted" => true, "deletedReason" => $reason]);
        doLog("rejectPost", true, $id, $user["_id"]);
    }
    header("Refresh: 0");
    die("rejected");
}

// ===================== Действия: жалобы на посты (flagsDeletion) =====================
if (isset($_POST["resolveReport"])) {
    $id = (int) clean($_POST["resolveReport"]);
    $flag = $db["flagsDeletion"]->findById($id);
    if (!empty($flag)) {
        $db["flagsDeletion"]->updateById($id, ["status" => 1, "processedBy" => $user["_id"]]);
        $db["posts"]->updateById($flag["post"], ["deleted" => true, "deletedReason" => $flag["reason"]]);
        doLog("resolveReport", true, $id, $user["_id"]);
    }
    header("Refresh: 0");
    die("resolved");
}

if (isset($_POST["dismissReport"])) {
    $id = (int) clean($_POST["dismissReport"]);
    $rejectedReason = clean($_POST["rejectedReason"] ?? "");
    $flag = $db["flagsDeletion"]->findById($id);
    if (!empty($flag)) {
        $db["flagsDeletion"]->updateById($id, ["status" => 2, "processedBy" => $user["_id"], "rejectedReason" => $rejectedReason]);
        doLog("dismissReport", true, $id, $user["_id"]);
    }
    header("Refresh: 0");
    die("dismissed");
}

// ===================== Данные для вкладок =====================
switch ($tab) {
    case "aqueue":
        $queue = $db["posts"]->findBy(["status", "==", "awaiting"], ["timestamp" => "ASC"]);
        foreach ($queue as $key => $post) {
            $queue[$key]["poster"] = $db["users"]->findById($post["user"]);
        }
        $smarty->assign("queue", $queue);
        $smarty->assign("pagetitle", $lang["approval_queue"]);
        break;

    case "preports":
        $reports = $db["flagsDeletion"]->findBy(["status", "==", 0], ["timestamp" => "ASC"]);
        foreach ($reports as $key => $report) {
            $reports[$key]["post"] = $db["posts"]->findById($report["post"]);
        }
        $smarty->assign("reports", $reports);
        $smarty->assign("pagetitle", $lang["post_reports"]);
        break;

    case "creports":
        // В движке пока нет механизма жалоб на комментарии (нет ни стора, ни формы подачи жалобы).
        // Показываем честную заглушку вместо придуманных данных.
        $smarty->assign("pagetitle", $lang["comment_reports"]);
        break;

    default:
        $tab = "home";
        $stats = [
            "posts" => $db["posts"]->count(),
            "users" => $db["users"]->count(),
            "comments" => $db["comments"]->count(),
            "forumThreads" => count($db["forumPosts"]->findBy(["parent", "==", null])),
            "pendingApproval" => count($db["posts"]->findBy(["status", "==", "awaiting"])),
            "pendingReports" => count($db["flagsDeletion"]->findBy(["status", "==", 0])),
        ];
        $smarty->assign("stats", $stats);
        $smarty->assign("pagetitle", $lang["admin"]);
}

$smarty->assign("tab", $tab);
$smarty->assign("page", "admin");
$smarty->assign("pages", $pages);

require "../endtime.php";

$smarty->display("part.top.tpl");
$smarty->display("page.admin.tpl");
$smarty->display("part.bottom.tpl");
