from fastapi import FastAPI
from transformers import pipeline


# NOTE - we configure docs_url to serve the interactive Docs at the root path
# of the app. This way, we can use the docs as a landing page for the app on Spaces.
app = FastAPI(docs_url="/")

pipe = pipeline("text2text-generation", model="google/flan-t5-small")


@app.get("/generate")
def generate(text: str):
    """
    Using the text2text-generation pipeline from `transformers`, generate text
    from the given input text. The model used is `google/flan-t5-small`, which
    can be found [here](https://huggingface.co/google/flan-t5-small).
    """
    output = pipe(text)
    return {"output": output[0]["generated_text"]}