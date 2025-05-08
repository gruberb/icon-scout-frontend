<template>
    <div
        v-if="errorDetails"
        class="relative z-50"
        aria-labelledby="error-modal-title"
        role="dialog"
        aria-modal="true"
    >
        <div
            class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
        ></div>
        <div class="fixed inset-0 z-10 overflow-y-auto">
            <div
                class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0"
            >
                <div
                    class="relative transform overflow-hidden rounded-lg bg-white px-4 pb-4 pt-5 text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-3xl sm:p-6"
                >
                    <div class="absolute right-0 top-0 pr-4 pt-4">
                        <button
                            @click="closeModal"
                            class="rounded-md bg-white text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
                        >
                            <span class="sr-only">Close</span>
                            <svg
                                class="h-6 w-6"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke-width="1.5"
                                stroke="currentColor"
                            >
                                <path
                                    stroke-linecap="round"
                                    stroke-linejoin="round"
                                    d="M6 18L18 6M6 6l12 12"
                                />
                            </svg>
                        </button>
                    </div>
                    <div class="mt-3 text-center sm:mt-0 sm:text-left">
                        <h3
                            class="text-lg font-semibold leading-6 text-gray-900"
                            id="error-modal-title"
                        >
                            Error Details for {{ errorDetails.url }}
                        </h3>
                        <div class="mt-4">
                            <div class="mb-4">
                                <div
                                    class="rounded-md bg-red-50 p-4"
                                >
                                    <div class="flex">
                                        <div class="flex-shrink-0">
                                            <svg
                                                class="h-5 w-5 text-red-400"
                                                viewBox="0 0 20 20"
                                                fill="currentColor"
                                                aria-hidden="true"
                                            >
                                                <path
                                                    fill-rule="evenodd"
                                                    d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z"
                                                    clip-rule="evenodd"
                                                />
                                            </svg>
                                        </div>
                                        <div class="ml-3">
                                            <h3 class="text-sm font-medium text-red-800">
                                                Status: {{ errorDetails.status }}
                                            </h3>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div v-if="errorDetails.error_reasons && errorDetails.error_reasons.length > 0">
                                <h4 class="text-sm font-semibold text-gray-900 mb-2">Error Reasons:</h4>
                                <ul
                                    class="bg-gray-50 rounded-lg overflow-auto max-h-[30vh] divide-y divide-gray-200"
                                >
                                    <li
                                        v-for="(reason, index) in errorDetails.error_reasons"
                                        :key="index"
                                        class="px-4 py-3 text-sm text-gray-700"
                                    >
                                        {{ reason }}
                                    </li>
                                </ul>
                            </div>

                            <div v-if="errorDetails.attempted_urls && Array.isArray(errorDetails.attempted_urls) && errorDetails.attempted_urls.length > 0" class="mt-4">
                                <h4 class="text-sm font-semibold text-gray-900 mb-2">Attempted URLs:</h4>
                                <div
                                    class="bg-gray-50 rounded-lg overflow-auto max-h-[30vh]"
                                >
                                    <table class="min-w-full divide-y divide-gray-200">
                                        <thead class="bg-gray-100">
                                            <tr>
                                                <th scope="col" class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">URL</th>
                                                <th scope="col" class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                                                <th scope="col" class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Error</th>
                                            </tr>
                                        </thead>
                                        <tbody class="bg-white divide-y divide-gray-200">
                                            <tr v-for="(url, index) in errorDetails.attempted_urls" :key="index">
                                                <td class="px-4 py-2 text-sm text-gray-900 break-all">{{ url && url.url ? url.url : 'Unknown URL' }}</td>
                                                <td class="px-4 py-2 text-sm">
                                                    <span
                                                        :class="{
                                                            'inline-flex rounded-full px-2 text-xs font-semibold leading-5': true,
                                                            'bg-green-100 text-green-800': url && url.success,
                                                            'bg-red-100 text-red-800': url && !url.success
                                                        }"
                                                    >
                                                        {{ url && url.success ? 'Success' : 'Failed' }}
                                                    </span>
                                                </td>
                                                <td class="px-4 py-2 text-sm text-gray-500 break-all">{{ url && url.error ? url.error : 'None' }}</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue';

const props = defineProps({
    errorDetails: {
        type: Object,
        default: null,
    },
});

const emit = defineEmits(['close']);

function closeModal() {
    emit('close');
}
</script>