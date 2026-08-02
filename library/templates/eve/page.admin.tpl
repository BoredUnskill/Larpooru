{include file="part.menu.tpl"}

<div class="mx-4 mt-2 text-sm">

    {if $tab == "home"}

        <p class="font-bold text-lg mb-2">{$lang.admin}</p>

        <table class="text-sm">
            <tr class="border-b border-gray-200">
                <td class="py-1 pr-4 font-bold">Total posts</td>
                <td class="py-1">{$stats.posts}</td>
            </tr>
            <tr class="border-b border-gray-200">
                <td class="py-1 pr-4 font-bold">Total users</td>
                <td class="py-1">{$stats.users}</td>
            </tr>
            <tr class="border-b border-gray-200">
                <td class="py-1 pr-4 font-bold">Total comments</td>
                <td class="py-1">{$stats.comments}</td>
            </tr>
            <tr class="border-b border-gray-200">
                <td class="py-1 pr-4 font-bold">Forum threads</td>
                <td class="py-1">{$stats.forumThreads}</td>
            </tr>
            <tr class="border-b border-gray-200">
                <td class="py-1 pr-4 font-bold">
                    <a href="admin.php?tab=aqueue" class="text-red-500 hover:text-red-300">Pending approval</a>
                </td>
                <td class="py-1">{$stats.pendingApproval}</td>
            </tr>
            <tr class="border-b border-gray-200">
                <td class="py-1 pr-4 font-bold">
                    <a href="admin.php?tab=preports" class="text-red-500 hover:text-red-300">Pending post reports</a>
                </td>
                <td class="py-1">{$stats.pendingReports}</td>
            </tr>
        </table>

    {elseif $tab == "aqueue"}

        <p class="font-bold text-lg mb-2">{$lang.approval_queue}</p>

        <table class="w-full text-sm">
            <thead>
                <tr class="border-b border-black text-left">
                    <th class="py-1">Post</th>
                    <th class="py-1">Uploader</th>
                    <th class="py-1">Reason</th>
                    <th class="py-1 w-40">Actions</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$queue item=item}
                    <tr class="border-b border-gray-200">
                        <td class="py-1">
                            <a href="browse.php?page=post&id={$item._id}"
                                class="text-red-500 hover:text-red-300">#{$item._id}</a>
                        </td>
                        <td class="py-1">{$item.poster.username}</td>
                        <td class="py-1 text-gray-500">{$item.statusReason}</td>
                        <td class="py-1">
                            <form method="POST" action="admin.php?tab=aqueue" class="inline">
                                <input type="hidden" name="approvePost" value="{$item._id}">
                                <button type="submit" class="text-green-700 hover:underline mr-2">Approve</button>
                            </form>
                            <form method="POST" action="admin.php?tab=aqueue" class="inline">
                                <input type="hidden" name="rejectPost" value="{$item._id}">
                                <input type="hidden" name="reason" value="Rejected in approval queue">
                                <button type="submit" class="text-red-500 hover:underline">Reject</button>
                            </form>
                        </td>
                    </tr>
                {foreachelse}
                    <tr>
                        <td colspan="4" class="text-center py-4 text-gray-500">Queue is empty.</td>
                    </tr>
                {/foreach}
            </tbody>
        </table>

    {elseif $tab == "preports"}

        <p class="font-bold text-lg mb-2">{$lang.post_reports}</p>

        <table class="w-full text-sm">
            <thead>
                <tr class="border-b border-black text-left">
                    <th class="py-1">Post</th>
                    <th class="py-1">Reported by</th>
                    <th class="py-1">Reason</th>
                    <th class="py-1 w-52">Actions</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$reports item=item}
                    <tr class="border-b border-gray-200">
                        <td class="py-1">
                            {if !empty($item.post)}
                                <a href="browse.php?page=post&id={$item.post._id}"
                                    class="text-red-500 hover:text-red-300">#{$item.post._id}</a>
                            {else}
                                <span class="text-gray-500">deleted post</span>
                            {/if}
                        </td>
                        <td class="py-1">{$item.username}</td>
                        <td class="py-1 text-gray-500">{$item.reason}</td>
                        <td class="py-1">
                            <form method="POST" action="admin.php?tab=preports" class="inline">
                                <input type="hidden" name="resolveReport" value="{$item._id}">
                                <button type="submit" class="text-red-500 hover:underline mr-2">Delete post</button>
                            </form>
                            <form method="POST" action="admin.php?tab=preports" class="inline">
                                <input type="hidden" name="dismissReport" value="{$item._id}">
                                <input type="hidden" name="rejectedReason" value="Dismissed by moderator">
                                <button type="submit" class="text-gray-500 hover:underline">Dismiss</button>
                            </form>
                        </td>
                    </tr>
                {foreachelse}
                    <tr>
                        <td colspan="4" class="text-center py-4 text-gray-500">No pending post reports.</td>
                    </tr>
                {/foreach}
            </tbody>
        </table>

    {elseif $tab == "creports"}

        <p class="font-bold text-lg mb-2">{$lang.comment_reports}</p>
        <p class="text-gray-500">Comment reporting isn't implemented in Xenooru yet — there's no way for users to
            report a comment, so there's nothing to show here. This tab is a placeholder until that feature exists.
        </p>

    {/if}

</div>
