<script lang="ts">
    import { createEventDispatcher, onDestroy, onMount } from "svelte";
    import { csvParse } from "d3-dsv";
    import Aux from "../lib/AuxBtn";
    import SkewedButton from "../lib/SkewedButton.svelte";
    import Overlay from "../lib/Overlay.svelte";
    import Card from "../lib/Card.svelte";

    const emit = createEventDispatcher();

    // the {something} of the ./data/{something} url
    export let base = "";

    let loading_finished = false;
    let loading_error = false;

    let show_listing = false;

    // html and csv contents
    let schema;
    let cards;

    // index of the currently displayed card
    let viewing_card: number = null;

    // whether the spin animation should play
    let spin: boolean = false;
    // display
    let show_back_instead_of_front: boolean = false;

    // Reactive hooks: These expressions run when any of the checked values change.
    $: if (viewing_card != null) {
        show_back_instead_of_front = false;
    }
    $: if (viewing_card != null) {
        $Aux.text = `${viewing_card + 1}/${cards.length}`;
    }

    onMount(() => {
        $Aux.text = null;
        $Aux.callback = () => {
            show_listing = !show_listing;
        };
        performLoad();
    });

    onDestroy(() => {
        $Aux.text = null;
        $Aux.callback = null;
    });

    // download all the data
    async function performLoad() {
        loading_finished = false;
        loading_error = false;
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
            loading_finished = true;
        } catch {
            loading_error = true;
        }
    }

    // play the card turning animation
    function turn() {
        if (spin) {
            return;
        }
        spin = true;
        setTimeout(() => {
            show_back_instead_of_front = !show_back_instead_of_front;
            setTimeout(() => {
                spin = false;
            }, 100);
        }, 100);
    }

    // Skip this many cards and check for wrapping around 0 and cards.length
    function jump(by: number) {
        // Offload to a variable to prevent rerendering
        let c = viewing_card + by;
        if (c < 0) {
            c = cards.length - 1;
        }
        if (c >= cards.length) {
            c = 0;
        }
        viewing_card = c;
    }

    // On card from list selected
    function selectCardFromList(index: number) {
        viewing_card = index;
        show_listing = false;
    }
</script>

{#if loading_finished && !loading_error}
    <!-- Main content -->
    <div class="card" class:show_back_instead_of_front class:spin>
        {#if viewing_card != null}
            {@html cards.columns.reduce(
                (html, word) =>
                    html.replaceAll(`{{${word}}}`, cards[viewing_card][word]),
                schema
            )}
        {/if}
    </div>

    <SkewedButton on:click={turn}>
        {show_back_instead_of_front ? "Skryj" : "Ukaž"} druhou stranu
    </SkewedButton>

    <div class="controls">
        <SkewedButton on:click={() => jump(-1)}>&lt;</SkewedButton>
        <SkewedButton on:click={() => jump(1)}>&gt;</SkewedButton>
    </div>

    {#if show_listing}
        <Overlay zIndex={1}>
            <div class="listing">
                {#each cards as card, i}
                    <Card on:click={() => selectCardFromList(i)}>
                        <div class="overlay-card">
                            <h1>{i + 1}</h1>
                            {cards.columns.reduce((content, word) => {
                                let w = card[word];
                                if (w != "") {
                                    content = content + w + "; ";
                                }
                                return content;
                            }, "")}
                        </div>
                    </Card>
                {/each}
            </div>
        </Overlay>
    {/if}
{:else if loading_error}
    <!-- Loading error -->
    <h2>při načítání došlo k chybě</h2>
    <SkewedButton on:click={performLoad}>zkusit znovu</SkewedButton>
{:else}
    <!-- Loading -->
    <h2>načítání...</h2>
{/if}

<style>
    @keyframes spin {
        0% {
            transform: scaleX(1);
        }

        50% {
            transform: scaleX(0);
        }

        100% {
            transform: scaleX(1);
        }
    }

    .card {
        width: 100%;
        max-width: 800px;
        height: 100%;
        padding: 16px 0;
        margin-bottom: 8px;
        display: flex;

        position: relative;
        flex: 1;
        flex-direction: column;
        align-items: center;
        text-align: center;
        overflow: auto;

        background: rgb(236, 235, 243);
        border-radius: 24px;
        box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
    }

    .card :global(img) {
        max-width: 95%;
    }

    .controls {
        margin-top: 8px;
        width: 90%;
        max-width: 600px;
        display: flex;
        flex-direction: row;
        justify-content: space-between;
    }

    .card.spin {
        animation: spin 0.2s cubic-bezier(0.37, 0, 0.63, 1);
    }

    .card:not(.show_back_instead_of_front) :global(.back) {
        display: none;
    }

    .card.show_back_instead_of_front :global(.front) {
        display: none;
    }

    .listing {
        display: flex;
        flex-direction: column;
        max-width: 800px;
        width: 100%;
    }

    .overlay-card {
        padding: 0 16px;
        flex: 1;
        display: flex;
        flex-direction: row;
        align-items: center;
    }

    .overlay-card h1 {
        margin: 8px 24px 8px 0px;
    }
</style>
