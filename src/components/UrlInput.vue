<template>
    <div class="bg-white shadow-sm rounded-lg p-6">
        <h2 class="text-lg font-semibold text-gray-900 mb-4">Input URLs</h2>
        <textarea
            v-model="urlInput"
            placeholder="Paste URLs separated by newline or comma"
            class="w-full min-h-[200px] p-3 border border-gray-300 rounded-md shadow-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        ></textarea>
        <div class="mt-4">
            <label class="block text-sm font-medium text-gray-700 mb-2">
                <input
                    type="file"
                    @change="handleFileUpload"
                    accept=".json,.txt"
                    class="mt-1 block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
                />
            </label>
        </div>
        <div class="mt-4 space-y-3">
            <button
                @click="submitUrls"
                :disabled="!hasInput"
                class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:bg-gray-300 disabled:cursor-not-allowed"
            >
                Fetch Favicons
            </button>
            <ManifestButton
                :results="results"
                @manifest-generated="$emit('manifest-generated', $event)"
            />
        </div>
    </div>
</template>
<script setup>
import { ref, computed } from "vue";
import ManifestButton from "./ManifestButton.vue"; // Add this import

const props = defineProps({
    results: {
        type: Array,
        required: true,
    },
});

const emit = defineEmits(["on-submit", "manifest-generated"]);
const urlInput = ref("");
const hasInput = computed(() => urlInput.value.trim().length > 0);

function submitUrls() {
    const normalizedInput = urlInput.value.replace(/\r\n/g, "\n");
    const urls = normalizedInput
        .split("\n")
        .flatMap((line) => line.split(","))
        .map((u) => u.trim())
        .filter((u) => u.length > 0);
    const uniqueUrls = [...new Set(urls)];
    if (uniqueUrls.length > 0) {
        emit("on-submit", uniqueUrls);
    }
}

async function generateManifest() {
    try {
        const response = await axios.post("/api/manifest", props.results);
        emit("manifest-generated", response.data);
    } catch (error) {
        console.error("Error generating manifest:", error);
    }
}

function handleFileUpload(event) {
    const file = event.target.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (e) => {
        const content = e.target.result;
        try {
            const parsed = JSON.parse(content);
            if (Array.isArray(parsed)) {
                urlInput.value = parsed.join("\n");
            } else {
                urlInput.value = content;
            }
        } catch {
            urlInput.value = content;
        }
    };
    reader.readAsText(file);
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
