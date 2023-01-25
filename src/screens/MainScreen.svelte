<script lang="ts">
    import { createEventDispatcher, onDestroy, onMount } from "svelte";
    import Aux from "../lib/AuxBtn";
    import Card from "../lib/Card.svelte";
    import SkewedButton from "../lib/SkewedButton.svelte";

    let s = createEventDispatcher();

    let listing: any[] = null;
    let error_loading = false;

    async function performLoad() {
        error_loading = false;
        listing = null;
        try {
            let f = await fetch("data/listing.json", { cache: "no-store" });
            listing = await f.json();
        } catch {
            error_loading = true;
        }
    }

    onMount(() => {
        performLoad();
        $Aux.text = "načíst znovu";
        $Aux.callback = performLoad;
    });

    onDestroy(() => {
        $Aux.text = null;
        $Aux.callback = null;
    });

    function load(i) {
        s("begin", listing[i].contents);
    }
</script>

{#if !listing && !error_loading}
    <h2>načítání...</h2>
{:else if !error_loading}
    <h2>Zvol balík k otevření</h2>
    <div class="listing">
        {#each listing as item, i}
            <Card on:click={() => load(i)}>
                <h1>
                    {item.name}
                </h1>
                {item.description}
            </Card>
        {/each}
    </div>
{:else}
    <h2>při načítání došlo k chybě</h2>
    <SkewedButton on:click={performLoad}>zkusit znovu</SkewedButton>
{/if}

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
