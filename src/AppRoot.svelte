<script lang="ts">
    import MainScreen from "./screens/MainScreen.svelte";
    import Aux from "./AuxBtn";
    import SkewedButton from "./lib/SkewedButton.svelte";
    import { version } from "../package.json";
    import CardView from "./screens/CardView.svelte";

    let openedPackUrl = null;

    function info() {
        alert(`PikoAnki verze ${version}\nVytvořil Daniel Sýkora`);
    }

    function begin(e) {
        openedPackUrl = e.detail;
        screen = ScreenState.CardView;
    }

    enum ScreenState {
        Main,
        CardView,
    }

    let screen = ScreenState.Main;
</script>

<div class="root">
    <div class="header">
        <SkewedButton gravitate="left" on:click={info}>PikoAnki</SkewedButton>
        <div style="width: 100%;" />
        {#if $Aux.text}
            <SkewedButton
                gravitate="right"
                on:click={$Aux.callback}
                background_color="gray"
            >
                {$Aux.text}
            </SkewedButton>
        {/if}
    </div>

    <div class="content">
        <div class="wrap">
            {#if screen == ScreenState.Main}
                <MainScreen on:begin={begin} />
            {:else if screen == ScreenState.CardView}
                <CardView
                    on:close={() => {
                        screen = ScreenState.Main;
                    }}
                    base={openedPackUrl}
                />
            {/if}
        </div>
    </div>
</div>

<style>
    .root {
        display: flex;
        flex-direction: column;
        background-color: silver;
        height: 100%;
    }

    .header {
        display: flex;
        flex-direction: row;
        background-color: #2d2d2d;
        box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
        color: white;
        align-items: center;
        font-weight: bold;
        height: 48px;
    }

    .content {
        display: flex;
        height: 100%;
        width: 100%;
        overflow: hidden;
    }

    .wrap {
        display: flex;
        width: 100%;
        overflow: hidden;
        flex-direction: column;
        align-items: center;
        padding: 16px;
    }
</style>
