{include file="part.menu.tpl"}

<div class="mx-4 mt-2 max-w-2xl">

    <form method="GET" name="tagsearch" action="tags.php" class="mb-2">
        <input type="text" name="page" value="tags" hidden readonly>
        <label for="tagname" class="text-sm">{$lang.name}:</label>
        <input type="text" name="name" id="tagname" value="{$search|escape}" class="px-1 text-sm">

        <label for="tagcategory" class="text-sm ml-2">Category:</label>
        <select name="category" id="tagcategory" class="text-sm">
            <option value="">Any</option>
            <option value="tag" {if $category == "tag"}selected{/if}>{$lang.general}</option>
            <option value="artist" {if $category == "artist"}selected{/if}>{$lang.artists}</option>
            <option value="character" {if $category == "character"}selected{/if}>{$lang.characters}</option>
            <option value="copyright" {if $category == "copyright"}selected{/if}>{$lang.copyrights}</option>
            <option value="meta" {if $category == "meta"}selected{/if}>{$lang.metas}</option>
        </select>

        <label for="tagorder" class="text-sm ml-2">Order:</label>
        <select name="order" id="tagorder" class="text-sm">
            <option value="count" {if $order == "count"}selected{/if}>Most used</option>
            <option value="newest" {if $order == "newest"}selected{/if}>Newest</option>
            <option value="oldest" {if $order == "oldest"}selected{/if}>Oldest</option>
            <option value="name" {if $order == "name"}selected{/if}>Name (A-Z)</option>
        </select>

        <button type="submit"
            class="text-sm text-center bg-red-500 hover:bg-red-300 text-white px-2 ml-2">{$lang.search}</button>
    </form>

    <p class="font-bold">{$lang.tags}</p>
    <ul class="text-sm">
        {foreach from=$tags item=item}
            <li>
                <a href="wiki.php?term={$item.full}" class="text-red-500 hover:text-red-300">?</a>
                <a href="browse.php?page=search&query={$item.full}" class="hover:underline">+</a>
                <a href="browse.php?page=search&query=-{$item.full}" class="hover:underline">-</a>
                {if $item.type == "copyright"}
                    <a href="browse.php?page=search&query={$item.full}"
                        class="text-fuchsia-500 hover:text-red-300">{str_replace("_", " ", $item.name)}</a>
                {elseif $item.type == "character"}
                    <a href="browse.php?page=search&query={$item.full}"
                        class="text-lime-500 hover:text-red-300">{str_replace("_", " ", $item.name)}</a>
                {elseif $item.type == "artist"}
                    <a href="browse.php?page=search&query={$item.full}"
                        class="text-indigo-500 hover:text-red-300">{str_replace("_", " ", $item.name)}</a>
                {elseif $item.type == "meta"}
                    <a href="browse.php?page=search&query={$item.full}"
                        class="text-orange-500 hover:text-red-300">{str_replace("_", " ", $item.name)}</a>
                {else}
                    <a href="browse.php?page=search&query={$item.full}"
                        class="text-red-500 hover:text-red-300">{str_replace("_", " ", $item.name)}</a>
                {/if}
                {$item.count}
            </li>
        {foreachelse}
            <li class="text-gray-500">No tags found.</li>
        {/foreach}
    </ul>

    {if $totalPages > 1}
        <p class="mt-2 text-sm">
            {if $currentPage > 1}
                <a href="tags.php?page=tags&name={$search|escape:'url'}&category={$category|escape:'url'}&order={$order|escape:'url'}&pagination={$currentPage-1}"
                    class="text-red-500 hover:text-red-300">&laquo; Prev</a>
            {/if}
            {$lang.page} {$currentPage} / {$totalPages}
            {if $currentPage < $totalPages}
                <a href="tags.php?page=tags&name={$search|escape:'url'}&category={$category|escape:'url'}&order={$order|escape:'url'}&pagination={$currentPage+1}"
                    class="text-red-500 hover:text-red-300">Next &raquo;</a>
            {/if}
        </p>
    {/if}

</div>
