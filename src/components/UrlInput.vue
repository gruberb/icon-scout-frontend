<template>
    <div class="bg-white shadow-sm rounded-lg p-8">
        <div class="space-y-6">
            <!-- Manual Input Section -->
            <div>
                <h2 class="text-lg font-semibold text-gray-900">Add URLs</h2>
                <p class="mt-1 text-sm text-gray-500">
                    Enter URLs manually or paste a list
                </p>
                <textarea
                    v-model="urlInput"
                    placeholder="Enter URLs (one per line)"
                    class="mt-3 w-full min-h-[180px] p-4 border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-gray-900 placeholder-gray-400"
                ></textarea>
            </div>

            <!-- Upload Section -->
            <div class="border-t border-gray-200 pt-6">
                <h3
                    class="text-sm font-medium text-gray-900 uppercase tracking-wide"
                >
                    Import URLs
                </h3>

                <!-- URL List Upload -->
                <div
                    class="mt-4 p-4 bg-gray-50 rounded-lg border border-gray-200 hover:border-gray-300 transition-colors"
                >
                    <label class="block cursor-pointer">
                        <div class="flex items-start">
                            <div class="flex-shrink-0 mt-1">
                                <svg
                                    class="w-5 h-5 text-gray-400"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                                    />
                                </svg>
                            </div>
                            <div class="ml-3">
                                <div class="text-sm font-medium text-gray-900">
                                    URL List
                                </div>
                                <div class="text-xs text-gray-500">
                                    Upload a .txt or .json file containing URLs
                                </div>
                                <input
                                    type="file"
                                    @change="handleUrlListUpload"
                                    accept=".json,.txt"
                                    class="mt-2 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-medium file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                                />
                            </div>
                        </div>
                    </label>
                </div>

                <!-- Firefox Bookmarks Upload -->
                <div
                    class="mt-4 p-4 bg-gray-50 rounded-lg border border-gray-200 hover:border-gray-300 transition-colors"
                >
                    <label class="block cursor-pointer">
                        <div class="flex items-start">
                            <div class="flex-shrink-0 mt-1">
                                <svg
                                    class="w-5 h-5 text-gray-400"
                                    fill="none"
                                    stroke="currentColor"
                                    viewBox="0 0 24 24"
                                >
                                    <path
                                        stroke-linecap="round"
                                        stroke-linejoin="round"
                                        stroke-width="2"
                                        d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z"
                                    />
                                </svg>
                            </div>
                            <div class="ml-3">
                                <div class="text-sm font-medium text-gray-900">
                                    Firefox Bookmarks
                                </div>
                                <div class="text-xs text-gray-500">
                                    Import from Firefox bookmarks backup
                                </div>
                                <input
                                    type="file"
                                    @change="handleBookmarksUpload"
                                    accept=".json"
                                    class="mt-2 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-medium file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                                />
                                <div class="mt-2 text-xs text-gray-500">
                                    Bookmarks → Manage Bookmarks → Backup... →
                                    Export Bookmarks to JSON
                                </div>
                            </div>
                        </div>
                    </label>
                </div>
            </div>

            <!-- Action Buttons -->
            <div class="border-t border-gray-200 pt-6 space-y-4">
                <button
                    @click="submitUrls"
                    :disabled="!hasInput"
                    class="w-full flex justify-center items-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
                >
                    <svg
                        class="w-5 h-5 mr-2"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"
                        />
                    </svg>
                    Fetch Favicons
                </button>

                <ManifestButton
                    :results="results"
                    @manifest-generated="$emit('manifest-generated', $event)"
                />
            </div>
        </div>
    </div>
</template>
<script setup>
import { ref, computed } from "vue";
import ManifestButton from "./ManifestButton.vue";

const props = defineProps({
    results: {
        type: Array,
        required: true,
    },
});

const emit = defineEmits(["on-submit", "manifest-generated"]);
const urlInput = ref("");
const hasInput = computed(() => urlInput.value.trim().length > 0);

function extractRootDomain(url) {
    try {
        // Handle special protocols
        if (url.startsWith("about:")) {
            return url;
        }

        // Get domain by finding the first / after the protocol
        const protocolRemoved = url.replace(/^(https?:\/\/)/, "");
        const slashIndex = protocolRemoved.indexOf("/");

        // If there's no slash, return the whole thing
        if (slashIndex === -1) {
            return protocolRemoved;
        }

        // Get everything before the slash
        const domain = protocolRemoved.substring(0, slashIndex);
        return domain.replace(/^www\./, "");
    } catch (error) {
        return url;
    }
}

function extractBookmarkUrls(node) {
    let urls = [];
    if (node.uri && node.typeCode === 1) {
        // Extract only the domain from the URI
        urls.push(extractRootDomain(node.uri));
    }
    if (node.children && Array.isArray(node.children)) {
        for (const child of node.children) {
            urls = urls.concat(extractBookmarkUrls(child));
        }
    }
    return urls;
}

function handleUrlListUpload(event) {
    const file = event.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (e) => {
        const content = e.target.result;
        try {
            const parsed = JSON.parse(content);
            if (Array.isArray(parsed)) {
                // Extract domains from the URLs before joining
                urlInput.value = parsed
                    .map((url) => extractRootDomain(url))
                    .join("\n");
            } else {
                // Split by newlines and process each URL
                urlInput.value = content
                    .split(/[\n,]/)
                    .map((url) => url.trim())
                    .filter((url) => url.length > 0)
                    .map((url) => extractRootDomain(url))
                    .join("\n");
            }
        } catch {
            // If not JSON, treat as plain text with URLs
            urlInput.value = content
                .split(/[\n,]/)
                .map((url) => url.trim())
                .filter((url) => url.length > 0)
                .map((url) => extractRootDomain(url))
                .join("\n");
        }
    };
    reader.readAsText(file);
    event.target.value = "";
}

function handleBookmarksUpload(event) {
    const file = event.target.files?.[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (e) => {
        const content = e.target.result;
        try {
            const parsed = JSON.parse(content);
            if (parsed.children) {
                const urls = extractBookmarkUrls(parsed);
                urlInput.value = [...new Set(urls)].join("\n"); // Remove duplicates
            } else {
                alert(
                    "The uploaded file does not appear to be a valid Firefox bookmarks backup.",
                );
            }
        } catch (error) {
            alert(
                "Error parsing the bookmarks file. Please ensure it is a valid Firefox bookmarks backup.",
            );
        }
    };
    reader.readAsText(file);
    event.target.value = "";
}

function submitUrls() {
    const normalizedInput = urlInput.value.replace(/\r\n/g, "\n");
    const urls = normalizedInput
        .split(/[\n,]/)
        .map((u) => u.trim())
        .filter((u) => u.length > 0);

    const uniqueUrls = [...new Set(urls)];
    if (uniqueUrls.length > 0) {
        emit("on-submit", uniqueUrls);
    }
}
</script>
