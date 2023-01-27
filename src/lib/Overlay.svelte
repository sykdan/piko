<script>
    import { fade, scale } from "svelte/transition";
    export let zIndex = 1;
</script>

<div class="overlay-wrap" in:fade out:fade={{duration: 100}}>
    <div
        class="overlay"
        style="z-index: {zIndex}"
        in:scale={{ start: 1.2 }}
        out:fade={{duration: 100}}
    >
        <slot />
    </div>
</div>

<style>
    .overlay-wrap {
        position: fixed;
        top: 48px;
        left: 0;
        width: 100%;
        height: calc(100% - 48px);
        display: flex;
        overflow: hidden;
    }
    
    .overlay {
        padding: 16px;
        overflow-y: auto;
        width: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        background-color: rgba(0, 0, 0, 0.5);
        overflow-x: hidden;
    }

    @media (max-width: 600px) {
        .overlay {
            padding-left: 2px;
            padding-right: 2px;
        }
    }
</style>
