<?php

require "../autoload.php";

$page = "tags";
$title = "Tags";
$pages["isTags"] = true;

$search = clean($_GET["name"] ?? "");
$category = clean($_GET["category"] ?? "");
$order = clean($_GET["order"] ?? "count"); // count | name | newest | oldest
$currentPage = max(1, (int) clean($_GET["pagination"] ?? 1));
$perpage = $config["perpage"]["tags"];
$skip = ($currentPage - 1) * $perpage;

// Собираем условия фильтра
$where = [];
if (!empty($search)) {
    $where[] = ["name", "LIKE", "%{$search}%"];
}
if ($category !== "") {
    if (!empty($where)) $where[] = "AND";
    $where[] = ["type", "==", $category];
}

// Считаем общее количество (для пагинации)
$countQuery = $db["tags"]->createQueryBuilder();
if (!empty($where)) $countQuery = $countQuery->where($where);
$totalTags = count($countQuery->getQuery()->fetch());

// Основной запрос страницы
$query = $db["tags"]->createQueryBuilder();
if (!empty($where)) $query = $query->where($where);

switch ($order) {
    case "name":
        $query = $query->orderBy(["name" => "ASC"]);
        break;
    case "oldest":
        $query = $query->orderBy(["timestamp" => "ASC"]);
        break;
    case "newest":
        $query = $query->orderBy(["timestamp" => "DESC"]);
        break;
    default: // count — сортируем после подсчёта использований
        $query = $query->orderBy(["timestamp" => "DESC"]);
}

// Если сортировка по количеству — берём с запасом больше и досортировываем после подсчёта
$fetchLimit = ($order === "count") ? ($skip + $perpage + 200) : $perpage;
$fetchSkip = ($order === "count") ? 0 : $skip;

$tags = $query->skip($fetchSkip)->limit($fetchLimit)->getQuery()->fetch();

// Считаем количество постов на каждый тег через tagRelations
foreach ($tags as $key => $tag) {
    $tags[$key]["count"] = count($db["tagRelations"]->findBy(["full", "==", $tag["full"]]));
}

if ($order === "count") {
    usort($tags, function ($a, $b) {
        return $b["count"] <=> $a["count"];
    });
    $tags = array_slice($tags, $skip, $perpage);
}

$smarty->assign("tags", $tags);
$smarty->assign("search", $search);
$smarty->assign("category", $category);
$smarty->assign("order", $order);
$smarty->assign("currentPage", $currentPage);
$smarty->assign("totalPages", max(1, ceil($totalTags / $perpage)));

require "../endtime.php";

$smarty->display("part.top.tpl");
$smarty->display("page.tags.tpl");
$smarty->display("part.bottom.tpl");
