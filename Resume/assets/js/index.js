//Lambda function trigger

const counter = document.querySelector(".counter-number");

async function updateCounter() {
    try {
        let response = await fetch("https://gvbkx22smhcdszl4stqzg7p6pu0jasax.lambda-url.us-east-1.on.aws/");
        
        if (!response.ok) {
            throw new Error(`HTTP error! Status: ${response.status}`);
        }

        let data = await response.json();
        console.log("Lambda Response:", data);

        counter.innerHTML = `Views: ${data.views}`;
    } catch (error) {
        console.error("Error fetching view count:", error);
        counter.innerHTML = "Views: Error";
    }
}

updateCounter();
