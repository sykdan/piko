<script lang="ts">
    import { createEventDispatcher, onDestroy, onMount } from "svelte";
    import Aux from "../lib/AuxButton";
    import Card from "../lib/Card.svelte";
    import ErrorWidget from "../lib/ErrorWidget.svelte";
    import LoadingWidget from "../lib/LoadingWidget.svelte";
    import SkewedButton from "../lib/SkewedButton.svelte";

    let emit = createEventDispatcher();

    onMount(() => {
        $Aux.text = "načíst znovu";
        $Aux.callback = load;

        let hash = window.location.hash.substring(1);
        if (hash) {
            openCardPack(hash);
        }
    });

    onDestroy(() => {
        $Aux.text = null;
        $Aux.callback = null;
    });

    let listing: any[] = null;

    let loading = _fetchData();
    async function _fetchData() {
        let f = await fetch("data/listing.json", { cache: "no-store" });
        listing = await f.json();
    }

    function load() {
        loading = _fetchData();
    }

    function openCardPack(name) {
        emit("begin", name);
    }
</script>

{#await loading}
    <LoadingWidget />
{:then}
    <h2>Zvol balík k otevření</h2>
    <div class="listing">
        {#each listing as item, i}
            <Card on:click={() => openCardPack(item.contents)}>
                <h1>
                    {item.name}
                </h1>
                {item.description}
            </Card>
        {/each}
    </div>
    <SkewedButton
        on:click={() => (window.location.href = "https://varnaparna.fun/")}
        >zpátky do várny</SkewedButton
    >
{:catch}
    <ErrorWidget>Při načítání došlo k chybě</ErrorWidget>
    <SkewedButton on:click={load}>Zkusit znovu</SkewedButton>
{/await}

<style>
    .listing {
        display: flex;
        flex-direction: column;
        justify-content: center;
        max-width: 800px;
        margin-bottom: 8px;
    }

    .listing :global(h1) {
        margin-top: 0;
        margin-bottom: 8px;
    }
</style>
