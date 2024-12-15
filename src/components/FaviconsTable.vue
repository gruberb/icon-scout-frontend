<template>
    <div class="favicons-table-container">
        <div v-if="loading">Loading...</div>
        <div v-else-if="results.length === 0">
            No results yet. Submit some URLs!
        </div>
        <table v-else>
            <thead>
                <tr>
                    <th>URL</th>
                    <th>Status</th>
                    <th>MIME Type</th>
                    <th>Width</th>
                    <th>Height</th>
                    <th>Byte Size</th>
                    <th>Path</th>
                    <th>Attempted URLs</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(res, index) in results" :key="index">
                    <td>{{ res.url }}</td>
                    <td>{{ res.status }}</td>
                    <td>{{ res.mime_type || "N/A" }}</td>
                    <td>{{ res.width || "N/A" }}</td>
                    <td>{{ res.height || "N/A" }}</td>
                    <td>{{ res.byte_size || "N/A" }}</td>
                    <td>
                        <template v-if="res.path">
                            <a :href="res.path" target="_blank">View</a>
                        </template>
                        <template v-else>N/A</template>
                    </td>
                    <td>
                        <div
                            v-if="
                                res.attempted_urls &&
                                res.attempted_urls.length > 0
                            "
                        >
                            <ul>
                                <li
                                    v-for="(url, i) in res.attempted_urls"
                                    :key="i"
                                >
                                    {{ url }}
                                </li>
                            </ul>
                        </div>
                        <div v-else>N/A</div>
                    </td>
                </tr>
            </tbody>
        </table>
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
</script>

<style scoped>
.favicons-table-container {
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 1rem;
}

th,
td {
    border: 1px solid #ddd;
    padding: 0.5rem;
}

th {
    background: #eee;
    text-align: left;
}
</style>
