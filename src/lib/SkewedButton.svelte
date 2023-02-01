<script>
    import { createEventDispatcher } from "svelte";

    export let gravitate = null;
    export let background = "rgb(245,94,10)";

    let emit = createEventDispatcher();

    function clicked() {
        emit("click");
    }
</script>

<button
    class="button"
    style={(gravitate ? `margin-${gravitate}: -10px;` : "") +
        `background: ${background}`}
    on:click={clicked}
>
    <div class="text">
        <slot />
    </div>
</button>

<style>
    .button {
        display: flex;
        flex-direction: row;

        height: 48px;
        border: none;
        user-select: none;

        padding: 0 15px;
        transform: skewX(-20deg);
        transition: 0.2s;
        align-items: center;
    }

    .button:hover {
        padding: 0 20px;
        filter: brightness(1.1);
    }
    
    .button:active {
        padding: 0 10px;
        filter: none;
    }

    .text {
        padding: 0 16px;
        transform: skewX(20deg);
        filter: none;
        font-size: 24px;
        font-weight: bold;
        color: white;
        white-space: nowrap;
    }
</style>
