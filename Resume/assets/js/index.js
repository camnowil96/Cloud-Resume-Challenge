//Lambda function trigger

const counter = document.querySelector(".counter-number");
async function updateCounter() {
    let response = await fetch("https://gvbkx22smhcdszl4stqzg7p6pu0jasax.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    counter.innerHTML = ' Views: $(data)';
}

updateCounter();