<script lang="ts">
    import { createEventDispatcher, onDestroy, onMount } from "svelte";
    import Aux from "../lib/AuxBtn";
    import Card from "../lib/Card.svelte";
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
    <h2>načítání...</h2>
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
{:catch}
    <h2>při načítání došlo k chybě</h2>
    <SkewedButton on:click={load}>zkusit znovu</SkewedButton>
{/await}

<style>
    .listing {
        display: flex;
        flex-direction: column;
        justify-content: center;
        max-width: 800px;
    }

    .listing :global(h1) {
        margin-top: 0;
        margin-bottom: 8px;
    }
</style>
