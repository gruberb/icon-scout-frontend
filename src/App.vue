<template>
    <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-50">
        <header class="bg-gradient-to-r from-blue-600 to-indigo-600 shadow-lg">
            <div class="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
                <h1
                    class="text-2xl font-bold text-white flex items-center gap-2"
                >
                    <svg
                        class="h-8 w-8 text-white"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M4 5a2 2 0 012-2h12a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm0 8a2 2 0 012-2h12a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zm0 8a2 2 0 012-2h12a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2z"
                        />
                    </svg>
                    Icon Scout Dashboard
                </h1>
            </div>
        </header>
        <main class="py-8">
            <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
                <div class="flex gap-8">
                    <aside class="w-80 flex-shrink-0">
                        <div class="sticky top-8">
                            <UrlInput
                                @on-submit="fetchFavicons"
                                @manifest-generated="setManifest"
                                :results="results"
                            />
                        </div>
                    </aside>
                    <section
                        class="flex-1 rounded-lg backdrop-blur-sm bg-white/50 p-6 shadow-xl"
                    >
                        <FaviconsTable :results="results" :loading="loading" />
                    </section>
                </div>
            </div>
        </main>
        <ManifestGenerator :manifest="manifest" @close="manifest = null" />
    </div>
</template>

<style>
@import url("https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap");

:root {
    --font-sans: "Inter", system-ui, -apple-system, sans-serif;
}

body {
    font-family: var(--font-sans);
}

/* Add some subtle animations */
@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

main {
    animation: fadeIn 0.5s ease-out;
}
</style>
<script setup>
import { ref } from "vue";
import axios from "axios";
import UrlInput from "./components/UrlInput.vue";
import FaviconsTable from "./components/FaviconsTable.vue";
import ManifestGenerator from "./components/ManifestGenerator.vue";

const results = ref([]);
const loading = ref(false);
const manifest = ref(null);

function setManifest(newManifest) {
    manifest.value = newManifest;
}

async function fetchFavicons(urls) {
    loading.value = true;
    results.value = [];
    manifest.value = null;
    try {
        const res = await axios.post("/api/favicons", urls);
        results.value = res.data;
    } catch (error) {
        console.error("Error fetching favicons:", error);
    } finally {
        loading.value = false;
    }
}
</script>
