<template>
    <div class="url-input-container">
        <h2>Input URLs</h2>
        <textarea
            v-model="urlInput"
            placeholder="Paste URLs separated by newline or comma"
        ></textarea>
        <div class="file-upload">
            <input type="file" @change="handleFileUpload" accept=".json,.txt" />
        </div>
        <button @click="submitUrls" :disabled="!hasInput">
            Fetch Favicons
        </button>
    </div>
</template>

<script setup>
import { ref, computed } from "vue";

const emit = defineEmits(["on-submit"]);

const urlInput = ref("");

const hasInput = computed(() => urlInput.value.trim().length > 0);

function submitUrls() {
    // Normalize line endings (handle Windows-style \r\n)
    const normalizedInput = urlInput.value.replace(/\r\n/g, "\n");

    // Split by newline, then split each line by comma
    // flatMap merges the arrays so we end up with a single array of URLs
    const urls = normalizedInput
        .split("\n")
        .flatMap((line) => line.split(","))
        .map((u) => u.trim())
        .filter((u) => u.length > 0);

    // Remove duplicates to prevent fetching the same URL multiple times
    const uniqueUrls = [...new Set(urls)];

    if (uniqueUrls.length > 0) {
        emit("on-submit", uniqueUrls);
    }
}

function handleFileUpload(event) {
    const file = event.target.files[0];
    if (!file) return;

    const reader = new FileReader();
    reader.onload = (e) => {
        const content = e.target.result;
        try {
            // Attempt to parse as JSON array
            const parsed = JSON.parse(content);
            if (Array.isArray(parsed)) {
                // Join by newline to populate textarea
                urlInput.value = parsed.join("\n");
            } else {
                // Not an array, treat as text
                urlInput.value = content;
            }
        } catch {
            // Treat as text
            urlInput.value = content;
        }
    };
    reader.readAsText(file);
}
</script>

<style scoped>
.url-input-container {
    display: flex;
    flex-direction: column;
}
.url-input-container textarea {
    width: 100%;
    height: 200px;
    margin-bottom: 1rem;
    resize: vertical;
}
.file-upload {
    margin-bottom: 1rem;
}
</style>
