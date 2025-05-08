<template>
    <div class="bg-white rounded-lg shadow-sm overflow-hidden">
        <!-- Status Filter Buttons -->
        <div class="p-4 border-b border-gray-200">
            <div class="flex gap-2">
                <button
                    @click="activeFilter = 'all'"
                    :class="{
                        'px-3 py-1.5 rounded text-sm font-medium transition-colors': true,
                        'bg-gray-900 text-white': activeFilter === 'all',
                        'bg-gray-100 text-gray-600 hover:bg-gray-200':
                            activeFilter !== 'all',
                    }"
                >
                    All ({{ results.length }})
                </button>
                <button
                    @click="activeFilter = 'Success'"
                    :class="{
                        'px-3 py-1.5 rounded text-sm font-medium transition-colors': true,
                        'bg-green-600 text-white': activeFilter === 'Success',
                        'bg-green-50 text-green-600 hover:bg-green-100':
                            activeFilter !== 'Success',
                    }"
                >
                    Success ({{ successCount }})
                </button>
                <button
                    @click="activeFilter = 'Error'"
                    :class="{
                        'px-3 py-1.5 rounded text-sm font-medium transition-colors': true,
                        'bg-red-600 text-white': activeFilter === 'Error',
                        'bg-red-50 text-red-600 hover:bg-red-100':
                            activeFilter !== 'Error',
                    }"
                >
                    Error/Failed ({{ errorCount }})
                </button>
            </div>
        </div>
        
        <ErrorDetailsModal 
            :error-details="selectedError" 
            @close="closeErrorModal" 
        />

        <div v-if="loading" class="p-8 text-center">
            <div class="inline-flex items-center">
                <svg
                    class="animate-spin h-5 w-5 text-blue-600 mr-2"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                >
                    <circle
                        class="opacity-25"
                        cx="12"
                        cy="12"
                        r="10"
                        stroke="currentColor"
                        stroke-width="4"
                    ></circle>
                    <path
                        class="opacity-75"
                        fill="currentColor"
                        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                    ></path>
                </svg>
                Loading results...
            </div>
        </div>
        <div
            v-else-if="results.length === 0"
            class="p-8 text-center text-gray-500"
        >
            No results yet. Submit some URLs!
        </div>
        <div v-else class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-300">
                <thead>
                    <tr>
                        <th
                            scope="col"
                            class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6"
                        >
                            URL
                        </th>
                        <th
                            scope="col"
                            class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                        >
                            Status
                        </th>
                        <th
                            scope="col"
                            class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                        >
                            MIME
                        </th>
                        <th
                            scope="col"
                            class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                        >
                            Width
                        </th>
                        <th
                            scope="col"
                            class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                        >
                            Height
                        </th>
                        <th
                            scope="col"
                            class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                        >
                            Bytes
                        </th>
                        <th
                            scope="col"
                            class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                        >
                            Bucket
                        </th>
                        <th
                            scope="col"
                            class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                        >
                            Source
                        </th>
                        <th
                            scope="col"
                            class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900"
                        >
                            Details
                        </th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                    <tr v-for="(res, index) in filteredResults" :key="index">
                        <td
                            class="whitespace-nowrap py-4 pl-4 pr-3 text-sm text-gray-900 sm:pl-6"
                        >
                            {{ res.url }}
                        </td>
                        <td class="whitespace-nowrap px-3 py-4 text-sm">
                            <span
                                :class="{
                                    'inline-flex rounded-full px-2 text-xs font-semibold leading-5': true,
                                    'bg-green-100 text-green-800':
                                        res.status === 'Success',
                                    'bg-red-100 text-red-800':
                                        res.status === 'Error' || res.status === 'Failed',
                                }"
                            >
                                {{ res.status }}
                            </span>
                        </td>
                        <td
                            class="whitespace-nowrap px-3 py-4 text-sm text-gray-500"
                        >
                            {{ res.mime_type || "N/A" }}
                        </td>
                        <td
                            class="whitespace-nowrap px-3 py-4 text-sm text-gray-500"
                        >
                            {{ res.width || "N/A" }}
                        </td>
                        <td
                            class="whitespace-nowrap px-3 py-4 text-sm text-gray-500"
                        >
                            {{ res.height || "N/A" }}
                        </td>
                        <td
                            class="whitespace-nowrap px-3 py-4 text-sm text-gray-500"
                        >
                            {{ res.byte_size || "N/A" }}
                        </td>
                        <td
                            class="whitespace-nowrap px-3 py-4 text-sm text-gray-500"
                        >
                            <a
                                v-if="res.path"
                                :href="res.path"
                                target="_blank"
                                class="text-blue-600 hover:text-blue-800 hover:underline"
                            >
                                View
                            </a>
                            <span v-else>N/A</span>
                        </td>
                        <td class="px-3 py-4 text-sm text-gray-500">
                            <div
                                v-if="
                                    res.attempted_urls &&
                                    res.attempted_urls.length > 0
                                "
                            >
                                <div class="flex flex-col gap-1">
                                    <div
                                        v-for="(url, i) in res.attempted_urls"
                                        :key="i"
                                        class="relative"
                                    >
                                        <div
                                            class="text-xs text-gray-600 cursor-help flex items-center group"
                                        >
                                            <span
                                                class="truncate max-w-[200px] block"
                                                >{{ formatUrl(url) }}</span
                                            >
                                            <div
                                                class="hidden group-hover:block fixed transform -translate-y-8 bg-gray-900 text-white text-xs rounded py-1 px-2 shadow-lg z-50 whitespace-normal break-all max-w-md"
                                            >
                                                {{ url }}
                                                <div
                                                    class="absolute bottom-0 left-4 transform translate-y-full"
                                                >
                                                    <div
                                                        class="w-2 h-2 bg-gray-900 transform rotate-45"
                                                    ></div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div v-else>N/A</div>
                        </td>
                        <td class="px-3 py-4 text-sm">
                            <div v-if="res.status === 'Error' || res.status === 'Failed'" class="flex gap-2">
                                <button
                                    @click="showErrorDetails(res)"
                                    class="inline-flex items-center rounded-md bg-red-50 px-2 py-1 text-xs font-medium text-red-700 hover:bg-red-100 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2"
                                >
                                    View Errors
                                </button>
                                <button
                                    @click="openErrorInNewTab(res)"
                                    class="inline-flex items-center rounded-md bg-gray-50 px-2 py-1 text-xs font-medium text-gray-700 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
                                >
                                    New Tab
                                </button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from "vue";
import ErrorDetailsModal from "./ErrorDetailsModal.vue";

const props = defineProps({
    results: {
        type: Array,
        default: () => [],
    },
    loading: {
        type: Boolean,
        default: false,
    },
});

const activeFilter = ref("all");
const selectedError = ref(null);

// Computed properties for counts
const successCount = computed(
    () => props.results.filter((result) => result.status === "Success").length,
);

const errorCount = computed(
    () => props.results.filter((result) => result.status === "Error" || result.status === "Failed").length,
);

const filteredResults = computed(() => {
    if (activeFilter.value === "all") {
        return props.results;
    }
    if (activeFilter.value === "Error") {
        return props.results.filter(
            (result) => result.status === "Error" || result.status === "Failed",
        );
    }
    return props.results.filter(
        (result) => result.status === activeFilter.value,
    );
});

function formatUrl(urlObj) {
    const urlString = typeof urlObj === 'string' ? urlObj : urlObj.url;
    const maxLength = 30;
    if (urlString.length <= maxLength) return urlString;
    const start = urlString.substring(0, 20);
    const end = urlString.substring(urlString.length - 7);
    return `${start}...${end}`;
}

function showErrorDetails(result) {
    selectedError.value = result;
}

function closeErrorModal() {
    selectedError.value = null;
}

function openErrorInNewTab(result) {
    // Create a new HTML page with the error details
    const errorHTML = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Error Details for ${result.url}</title>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    </head>
    <body class="bg-gray-50 p-6">
        <div class="max-w-4xl mx-auto bg-white rounded-lg shadow-md p-6">
            <h1 class="text-xl font-semibold text-gray-900 mb-6">Error Details for ${result.url}</h1>
            
            <div class="mb-6">
                <div class="bg-red-50 p-4 rounded-md">
                    <div class="flex">
                        <div class="ml-3">
                            <h3 class="text-sm font-medium text-red-800">Status: ${result.status}</h3>
                        </div>
                    </div>
                </div>
            </div>
            
            ${result.error_reasons && result.error_reasons.length > 0 ? `
            <div class="mb-6">
                <h2 class="text-lg font-medium text-gray-900 mb-3">Error Reasons:</h2>
                <ul class="bg-gray-50 rounded-lg overflow-auto divide-y divide-gray-200">
                    ${result.error_reasons.map(reason => `
                    <li class="px-4 py-3 text-sm text-gray-700">${reason}</li>
                    `).join('')}
                </ul>
            </div>` : ''}
            
            ${result.attempted_urls && result.attempted_urls.length > 0 ? `
            <div>
                <h2 class="text-lg font-medium text-gray-900 mb-3">Attempted URLs:</h2>
                <div class="bg-gray-50 rounded-lg overflow-x-auto">
                    <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-100">
                            <tr>
                                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">URL</th>
                                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Error</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            ${result.attempted_urls.map(url => `
                            <tr>
                                <td class="px-4 py-2 text-sm text-gray-900 break-all">${url.url}</td>
                                <td class="px-4 py-2 text-sm">
                                    <span class="inline-flex rounded-full px-2 text-xs font-semibold leading-5 ${url.success ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}">
                                        ${url.success ? 'Success' : 'Failed'}
                                    </span>
                                </td>
                                <td class="px-4 py-2 text-sm text-gray-500 break-all">${url.error || 'None'}</td>
                            </tr>
                            `).join('')}
                        </tbody>
                    </table>
                </div>
            </div>` : ''}
        </div>
    </body>
    </html>
    `;
    
    // Open a new window with the error details
    const newWindow = window.open('', '_blank');
    newWindow.document.write(errorHTML);
    newWindow.document.close();
}
</script>
