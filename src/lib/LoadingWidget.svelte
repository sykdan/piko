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

    h2 {
        text-align: center;
    }

    div {
        margin-top: 16px;
    }

    img {
        animation: speen 2s infinite;
        height: 64px;
        width: 64px;
    }
</style>
