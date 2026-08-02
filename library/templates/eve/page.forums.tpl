{include file="part.menu.tpl"}

<div class="mx-4 mt-2">

    {if isset($error)}
        <p class="mt-2 mb-2"><span class="text-red-500">{$lang.error}:</span> {$error}</p>
    {/if}

    {if $page == "forums"}

        <p class="font-bold text-lg">{$lang.forums}</p>

        <table class="w-full text-sm mt-2">
            <thead>
                <tr class="border-b border-black text-left">
                    <th class="py-1">Name</th>
                    <th class="py-1 w-24">Threads</th>
                    <th class="py-1 w-24">Posts</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$forums item=item}
                    <tr class="border-b border-gray-200">
                        <td class="py-1">
                            <a href="forums.php?page=forum&id={$item._id}"
                                class="text-red-500 hover:text-red-300 font-bold">{$item.name}</a>
                            {if !empty($item.description)}
                                <br><span class="text-gray-500">{$item.description}</span>
                            {/if}
                        </td>
                        <td class="py-1">{$item.threadCount}</td>
                        <td class="py-1">{$item.postCount}</td>
                    </tr>
                {foreachelse}
                    <tr>
                        <td colspan="3" class="text-center py-4 text-gray-500">No forums yet.</td>
                    </tr>
                {/foreach}
            </tbody>
        </table>

        {if $logged && $userlevel.perms.is_forum_admin}
            <p class="font-bold mt-4">Create forum</p>
            <form method="POST" action="forums.php" class="mt-1">
                <label class="text-sm">Name:</label><br>
                <input type="text" name="name" class="border border-black px-1 w-full max-w-md"><br>
                <label class="text-sm">Description:</label><br>
                <input type="text" name="description" class="border border-black px-1 w-full max-w-md"><br>
                <button type="submit" name="createForum"
                    class="mt-1 text-sm bg-red-500 hover:bg-red-300 text-white px-2 py-1">Create</button>
            </form>
        {/if}

    {elseif $page == "forum"}

        <p class="text-sm"><a href="forums.php" class="text-red-500 hover:text-red-300">{$lang.forums}</a> &raquo; {$forum.name}</p>
        <p class="font-bold text-lg">{$forum.name}</p>
        {if !empty($forum.description)}
            <p class="text-sm text-gray-500 mb-2">{$forum.description}</p>
        {/if}

        <table class="w-full text-sm mt-2">
            <thead>
                <tr class="border-b border-black text-left">
                    <th class="py-1">Title</th>
                    <th class="py-1 w-32">Author</th>
                    <th class="py-1 w-20">Replies</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$threads item=item}
                    <tr class="border-b border-gray-200">
                        <td class="py-1">
                            <a href="forums.php?page=thread&id={$item._id}"
                                class="text-red-500 hover:text-red-300">{$item.title}</a>
                        </td>
                        <td class="py-1">
                            <a href="profile.php?id={$item.user._id}"
                                class="text-red-500 hover:text-red-300">{$item.user.username}</a>
                        </td>
                        <td class="py-1">{$item.replyCount}</td>
                    </tr>
                {foreachelse}
                    <tr>
                        <td colspan="3" class="text-center py-4 text-gray-500">No threads yet.</td>
                    </tr>
                {/foreach}
            </tbody>
        </table>

        {if $totalPages > 1}
            <p class="mt-2 text-sm">
                {if $currentPage > 1}
                    <a href="forums.php?page=forum&id={$forum._id}&pagination={$currentPage-1}"
                        class="text-red-500 hover:text-red-300">&laquo; Prev</a>
                {/if}
                {$lang.page} {$currentPage} / {$totalPages}
                {if $currentPage < $totalPages}
                    <a href="forums.php?page=forum&id={$forum._id}&pagination={$currentPage+1}"
                        class="text-red-500 hover:text-red-300">Next &raquo;</a>
                {/if}
            </p>
        {/if}

        {if $logged && $userlevel.perms.can_post_forum}
            <p class="font-bold mt-4">New thread</p>
            <form method="POST" action="forums.php" class="mt-1">
                <input type="hidden" name="forum_id" value="{$forum._id}">
                <label class="text-sm">Title:</label><br>
                <input type="text" name="title" class="border border-black px-1 w-full max-w-md"><br>
                <label class="text-sm">Content:</label><br>
                <textarea name="content" rows="4" class="border border-black px-1 w-full max-w-md"></textarea><br>
                <button type="submit" name="createThread"
                    class="mt-1 text-sm bg-red-500 hover:bg-red-300 text-white px-2 py-1">Post</button>
            </form>
        {elseif !$logged}
            <p class="text-sm text-gray-500 mt-4">You must be logged in to start a thread.</p>
        {/if}

    {elseif $page == "thread"}

        <p class="text-sm">
            <a href="forums.php" class="text-red-500 hover:text-red-300">{$lang.forums}</a> &raquo;
            <a href="forums.php?page=forum&id={$forum._id}" class="text-red-500 hover:text-red-300">{$forum.name}</a>
        </p>
        <p class="font-bold text-lg">{$thread.title}</p>

        <div class="border-b border-black py-2 text-sm">
            <b>{$thread.user.username}</b> <span class="text-gray-500">{$thread.timestamp}</span>
            <p class="mt-1">{$thread.content}</p>
        </div>

        {foreach from=$replies item=item}
            <div class="border-b border-gray-200 py-2 text-sm">
                <b>{$item.user.username}</b> <span class="text-gray-500">{$item.timestamp}</span>
                <p class="mt-1">{$item.content}</p>
            </div>
        {/foreach}

        {if $logged && $userlevel.perms.can_reply_forum}
            <p class="font-bold mt-4">Reply</p>
            <form method="POST" action="forums.php" class="mt-1">
                <input type="hidden" name="thread_id" value="{$thread._id}">
                <textarea name="content" rows="4" class="border border-black px-1 w-full max-w-md"></textarea><br>
                <button type="submit" name="createReply"
                    class="mt-1 text-sm bg-red-500 hover:bg-red-300 text-white px-2 py-1">Reply</button>
            </form>
        {elseif !$logged}
            <p class="text-sm text-gray-500 mt-4">You must be logged in to reply.</p>
        {/if}

    {/if}

</div>
