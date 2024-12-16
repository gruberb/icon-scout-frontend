<template>
    <div class="bg-white rounded-lg shadow-sm overflow-hidden">
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
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-200 bg-white">
                    <tr v-for="(res, index) in results" :key="index">
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
                                        res.status === 'Error',
                                    'bg-yellow-100 text-yellow-800':
                                        res.status === 'Failed',
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
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
<script setup>
import { defineProps } from "vue";

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

function formatUrl(url) {
    const maxLength = 30;
    if (url.length <= maxLength) return url;
    const start = url.substring(0, 20);
    const end = url.substring(url.length - 7);
    return `${start}...${end}`;
}
</script>
