<script lang="ts">
    import { createEventDispatcher, onDestroy, onMount } from "svelte";
    import { csvParse } from "d3-dsv";
    import Aux from "../AuxBtn";
    import SkewedButton from "../lib/SkewedButton.svelte";
    // the {something} of the ./data/{something} url
    export let base = "";

    let loaded = false;
    let loading_errored = false;

    // html and csv contents
    let schema;
    let cards;

    // index of the currently displayed card
    let viewing_card = null;

    let display_second_side = false;

    $: if (viewing_card != null) {
        display_second_side = false;
    }

    const emit = createEventDispatcher();

    async function performLoad() {
        loaded = false;
        loading_errored = false;
        schema = null;
        cards = null;
        viewing_card = null;

        const root = "./data/" + base + "/";

        try {
            let _sc = await fetch(root + "schema.html");
            let _ca = await fetch(root + "data.csv");
            if (!_sc.ok || !_ca.ok) {
                throw 0;
            }
            schema = await _sc.text();
            cards = csvParse(await _ca.text());

            viewing_card = 0;
            loaded = true;
        } catch {
            loading_errored = true;
        }
    }

    onMount(() => {
        $Aux.text = "jít zpět";
        $Aux.callback = () => {
            emit("close");
        };
        performLoad();
    });

    onDestroy(() => {
        $Aux.text = null;
        $Aux.callback = null;
    });

    function jump(by) {
        let c = viewing_card + by;
        if (c < 0) {
            c = cards.length - 1;
        }
        if (c >= cards.length) {
            c = 0;
        }

        viewing_card = c;
    }
</script>
    {#if loaded && !loading_errored}
        <div class="card" class:display_second_side>
            {#if viewing_card != null}
                <span class="index">
                    karta {viewing_card + 1}/{cards.length}
                </span>
                {@html cards.columns.reduce(
                    (html, word) =>
                        html.replaceAll(
                            `{{${word}}}`,
                            cards[viewing_card][word]
                        ),
                    schema
                )}
            {/if}
        </div>

        <SkewedButton
            on:click={() => {
                display_second_side = !display_second_side;
            }}
        >
            {display_second_side ? "Skryj" : "Ukaž"} druhou stranu
        </SkewedButton>

        <div class="controls">
            <SkewedButton on:click={() => jump(-1)}>&lt;</SkewedButton>
            <SkewedButton on:click={() => jump(1)}>&gt;</SkewedButton>
        </div>
    {:else if loading_errored}
        <h2>při načítání došlo k chybě</h2>
        <SkewedButton on:click={performLoad}>zkusit znovu</SkewedButton>
    {:else}
        <h2>načítání...</h2>
    {/if}

<style>
    .card {
        display: flex;
        flex: 1;
        flex-direction: column;
        background: white;
        padding: 16px 0;

        border-radius: 24px;
        margin-bottom: 16px;
        width: 100%;
        height: 100%;
        position: relative;
        overflow: scroll;

        align-items: center;
        text-align: center;
    }

    .card :global(img) {
        max-height: 500px;
        max-width: 500px;
    }

    .index {
        position: absolute;
        top: 16px;
        left: 16px;
    }

    .controls {
        margin-top: 16px;
        width: 100%;
        max-width: 600px;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
    }

    .card:not(.display_second_side) :global(.back) {
        display: none;
    }
</style>
