<template>
    <div class="app-container">
        <header class="app-header">
            <h1>Icon Scout Dashboard</h1>
        </header>
        <div class="main-content">
            <aside class="sidebar">
                <UrlInput @on-submit="fetchFavicons" />
            </aside>
            <section class="results">
                <FaviconsTable :results="results" :loading="loading" />
            </section>
        </div>
    </div>
</template>

<script setup>
import { ref } from "vue";
import axios from "axios";
import UrlInput from "./components/UrlInput.vue";
import FaviconsTable from "./components/FaviconsTable.vue";

const results = ref([]);
const loading = ref(false);

async function fetchFavicons(urls) {
    loading.value = true;
    results.value = [];
    try {
        // Use the relative API endpoint that the Ingress routes to the backend:
        const res = await axios.post("/api/favicons", urls);
        results.value = res.data;
    } catch (error) {
        console.error("Error fetching favicons:", error);
    } finally {
        loading.value = false;
    }
}
</script>
