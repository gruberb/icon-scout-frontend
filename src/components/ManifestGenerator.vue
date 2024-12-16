<template>
    <div
        v-if="manifest"
        class="relative z-50"
        aria-labelledby="modal-title"
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
                            id="modal-title"
                        >
                            Generated Manifest
                        </h3>
                        <pre
                            class="mt-4 bg-gray-50 p-4 rounded-lg overflow-auto max-h-[60vh] text-sm"
                            >{{ formattedManifest }}</pre
                        >
                    </div>
                    <div class="mt-5 sm:mt-4">
                        <button
                            @click="downloadManifest"
                            class="inline-flex w-full justify-center rounded-md bg-blue-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-blue-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-600"
                        >
                            Download manifest.json
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script setup>
import { computed } from "vue";

const props = defineProps({
    manifest: {
        type: Object,
        default: null,
    },
});

const emit = defineEmits(["close"]);

const formattedManifest = computed(() => {
    if (!props.manifest) return "";
    return JSON.stringify(props.manifest, null, 2);
});

function closeModal() {
    emit("close");
}

function downloadManifest() {
    if (!props.manifest) return;
    const blob = new Blob([JSON.stringify(props.manifest, null, 2)], {
        type: "application/json",
    });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "manifest.json";
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}
</script>
