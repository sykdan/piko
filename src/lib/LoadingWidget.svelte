<div>
    <img src="./assets/hourglass.svg" alt="Loading icon" />
    <h2>načítání...</h2>
</div>

<style>
    @keyframes speen {
        0% {
            transform: rotate(0deg);
        }
        95% {
            transform: rotate(360deg);
        }
        100% {
            transform: rotate(360deg);
        }
    }

    div {
        margin-top: 16px;
        text-align: center;
    }

    img {
        animation: speen 2s infinite;
        height: 64px;
        width: 64px;
    }
</style>
