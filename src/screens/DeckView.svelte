<script lang="ts">
    import { createEventDispatcher, onDestroy, onMount } from "svelte";
    import { csvParse } from "d3-dsv";
    import Aux from "../lib/AuxButton";
    import SkewedButton from "../lib/SkewedButton.svelte";
    import Overlay from "../lib/Overlay.svelte";
    import Card from "../lib/Card.svelte";
    import LoadingWidget from "../lib/LoadingWidget.svelte";
    import ErrorWidget from "../lib/ErrorWidget.svelte";

    const emit = createEventDispatcher();

    onMount(() => {
        $Aux.text = null;
        $Aux.callback = () => {
            show_listing = !show_listing;
        };
        window.addEventListener("keydown", keyboard_key);
    });

    onDestroy(() => {
        $Aux.text = null;
        $Aux.callback = null;
        window.removeEventListener("keydown", keyboard_key);
    });

    // the {something} of the ./data/{something} url
    export let base = "";

    // html and csv contents
    let schema;
    let cards;

    // index of the currently displayed card
    let viewing_card: number = null;

    let show_listing = false;

    // whether the spin animation should play
    let spin: boolean = false;
    // display
    let show_back_instead_of_front: boolean = false;

    // Reactive hooks: These expressions run when any of the checked values change.
    $: if (viewing_card != null) {
        show_back_instead_of_front = false;
    }

    $: if (viewing_card != null) {
        if (show_listing) {
            $Aux.text = "×";
        } else {
            $Aux.text = `${viewing_card + 1}/${cards.length}`;
        }
    }

    // download all the data
    let loading = _fetchData();
    async function _fetchData() {
        schema = null;
        cards = null;
        viewing_card = null;

        const root = "./data/" + base + "/";

        let _sc = await fetch(root + "schema.html");
        let _ca = await fetch(root + "data.csv");
        if (!_sc.ok || !_ca.ok) {
            throw 0;
        }
        schema = await _sc.text();
        cards = csvParse(await _ca.text());

        viewing_card = 0;
        window.location.hash = base;
    }

    function load() {
        loading = _fetchData();
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

    function randomize() {
        viewing_card = Math.floor(Math.random() * cards.length);
    }

    // On card from list selected
    function selectCardFromList(index: number) {
        viewing_card = index;
        show_listing = false;
    }

    function keyboard_key(e: KeyboardEvent) {
        if (e.key == "ArrowLeft") {
            jump(-1);
            e.preventDefault();
        }
        if (e.key == "ArrowRight") {
            jump(1);
            e.preventDefault();
        }
        if (e.key == " ") {
            turn();
            e.preventDefault();
        }
        if (e.key == "r") {
            randomize();
            e.preventDefault();
        }
    }
</script>

{#await loading}
    <LoadingWidget />
{:then}
    <div class="card" class:show_back_instead_of_front class:spin>
        {#if viewing_card != null}
            {@html cards.columns.reduce(
                (html, word) =>
                    html.replaceAll(
                        `{{${word}}}`,
                        cards[viewing_card][word].replaceAll("\n", "<br>")
                    ),
                schema
            )}
        {/if}
    </div>

    <SkewedButton on:click={turn}>Otočit kartu</SkewedButton>

    <div class="controls">
        <SkewedButton on:click={() => jump(-1)}>
            <img src="assets/arrow-left.svg" alt="" />
        </SkewedButton>
        <SkewedButton on:click={() => randomize()}>
            <img src="assets/random.svg" alt="" />
        </SkewedButton>
        <SkewedButton on:click={() => jump(1)}>
            <img src="assets/arrow-right.svg" alt="" />
        </SkewedButton>
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
{:catch}
    <ErrorWidget>při načítání došlo k chybě</ErrorWidget>
    <SkewedButton on:click={load}>zkusit znovu</SkewedButton>
{/await}

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
        width: calc(100% - 32px);
        max-width: 800px;
        height: 100%;
        padding: 16px 16px;
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
    }

    .overlay-card {
        padding: 0 16px;
        flex: 1;
        display: flex;
        flex-direction: row;
        align-items: center;
        max-width: 800px;
        width: 100%;
    }

    .overlay-card h1 {
        margin: 8px 24px 8px 0px;
    }

    :global(.back),
    :global(.front) {
        width: 100%;
    }

    .controls img {
        width: 48px;
        height: 48px;
        vertical-align: middle;
    }
</style>
