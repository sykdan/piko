<script lang="ts">
    // Screens
    import MainScreen from "./screens/MainScreen.svelte";
    import DeckView from "./screens/DeckView.svelte";

    // Components
    import SkewedButton from "./lib/SkewedButton.svelte";
    import Aux from "./lib/AuxButton";

    // Misc
    import { version } from "../package.json";

    enum ScreenState {
        MainScreen,
        DeckView,
    }

    let screen: ScreenState = ScreenState.MainScreen;

    let openedPackUrl: string = null;

    function home() {
        window.location.hash = "";
        if (screen == ScreenState.MainScreen) {
            alert(`PikoAnki verze ${version}\nVytvořil Daniel Sýkora`);
        } else {
            screen = ScreenState.MainScreen;
        }
    }

    function openCardPack(pack) {
        openedPackUrl = pack;
        screen = ScreenState.DeckView;
    }

    function begin(e) {
        openCardPack(e.detail);
    }
</script>

<div class="header">
    <SkewedButton
        gravitate="left"
        on:click={home}
        background="linear-gradient(90deg, rgba(194,1,20,1) 0%, rgba(245,94,10,1) 100%)"
        >Piko (Anki)</SkewedButton
    >
    <div style="width: 100%;" />
    {#if $Aux.text}
        <SkewedButton
            gravitate="right"
            on:click={$Aux.callback}
            background="rgb(109, 114, 117)"
        >
            {$Aux.text}
        </SkewedButton>
    {/if}
</div>

<div class="content">
    {#if screen == ScreenState.MainScreen}
        <MainScreen on:begin={begin} />
    {:else if screen == ScreenState.DeckView}
        <DeckView
            on:close={() => {
                screen = ScreenState.MainScreen;
            }}
            base={openedPackUrl}
        />
    {/if}
</div>

<style>
    .header {
        height: 48px;
        display: flex;

        flex-direction: row;
        align-items: center;

        color: white;
        background-color: #0f0f0f;
        box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
        font-weight: bold;
        z-index: 999;
    }

    .content {
        display: flex;
        height: calc(100% - 32px);
        width: calc(100% - 32px);
        overflow: hidden;
        padding: 16px;

        flex-direction: column;
        align-items: center;

        transition: 0.2s;
    }

    @media (max-width: 600px) {
        .content {
            padding: 8px 2px;
            height: calc(100% - 16px);
            width: calc(100% - 4px);
        }
    }
</style>
