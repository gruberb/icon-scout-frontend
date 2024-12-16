<template>
    <button
        @click="generateManifest"
        :disabled="!hasValidResults"
        class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 disabled:bg-gray-300 disabled:cursor-not-allowed"
    >
        Generate Manifest
    </button>
</template>
<script setup>
import { computed } from "vue";
import axios from "axios";

const props = defineProps({
    results: {
        type: Array,
        required: true,
    },
});
const emit = defineEmits(["manifest-generated"]);

const hasValidResults = computed(() => {
    return props.results.some((r) => r.status === "Success" && r.path);
});

async function generateManifest() {
    try {
        const response = await axios.post("/api/manifest", props.results);
        emit("manifest-generated", response.data);
    } catch (error) {
        console.error("Error generating manifest:", error);
    }
}
</script>
