
from llama_index.core import StorageContext,Settings,load_index_from_storage
from llama_iris import IRISVectorStore
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.huggingface import HuggingFaceEmbedding

prompt_path = "./data/prompts/medical_progress_notes_prompt.txt"

# iris connection url: "iris://username:password@server:port/namespace"
url = f"iris://_SYSTEM:SYS@localhost:1972/IRISAPP"

# These 2 lines are used to exchange OpenAI for Ollama.
Settings.embed_model = HuggingFaceEmbedding(model_name="BAAI/bge-m3")
Settings.llm = Ollama(model="llama3.2", request_timeout=360.0)
Settings.llm = Ollama(
    base_url="http://ollama:11434", # tell it to connect to the Ollama container
    model="llama3.2",
    request_timeout=360.0
)

vector_store = IRISVectorStore.from_params(
    connection_string=url,
    table_name="your_table_name",
    embed_dim = 1024 # HugginFace BAAI/bge-m3 dimensionality
)

def read_prompt(prompt_path: str):
    """
    Read the prompt for medical progress note parsing from a text file.
    """
    with open(prompt_path, "r") as f:
        return f.read()

#load the storage context saved in load_data.py
storage_context = StorageContext.from_defaults(vector_store=vector_store,persist_dir="storageExample")
index = load_index_from_storage(
    storage_context,
    # we can optionally override the embed_model here
    # it's important to use the same embed_model as the one used to build the index
    # embed_model=Settings.embed_model,
)
query_engine = index.as_query_engine()
prompt_data = read_prompt(prompt_path)
response = query_engine.query(prompt_data)

import textwrap
print(textwrap.fill(str(response), 100))

