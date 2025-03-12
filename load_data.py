import os
from dotenv import load_dotenv
from llama_index.core import SimpleDirectoryReader,StorageContext,VectorStoreIndex,Settings
from llama_iris import IRISVectorStore
from llama_index.embeddings.huggingface import HuggingFaceEmbedding
from llama_index.llms.ollama import Ollama

# iris connection url: "iris://username:password@server:port/namespace"
url = f"iris://teste:teste@localhost:51774/TESTE"

# data_example is the name of directory where the documents are
documents = SimpleDirectoryReader("data_example").load_data()
print("Document ID:", documents[0].doc_id)

# This line is configuring the BAAI/bge-m3 model because it's multilingual, so it is not necessary to put texts in English
Settings.embed_model = HuggingFaceEmbedding(model_name="BAAI/bge-m3")
# This line change the default LLM from OpenAI to Ollama. 
Settings.llm = Ollama(model="llama3.2", request_timeout=360.0)

vector_store = IRISVectorStore.from_params(
    connection_string=url,
    table_name="your_table_name",
    #embed_dim = 1536  # openai embedding dimension
    #embed_dim = 384 # HugginFace all-MiniLM-L6-v2 dimensionality
    embed_dim = 1024 # HugginFace BAAI/bge-m3 dimensionality 
    #embed_dim = 768 # HugginFace BAAI/bge-base-en-v1.5 dimensionality
)
storage_context = StorageContext.from_defaults(vector_store=vector_store)
index = VectorStoreIndex.from_documents(
    documents,
    storage_context=storage_context,
    show_progress=True,
)

index = VectorStoreIndex.from_vector_store(vector_store=vector_store)

# signals to "index" that we want to use the documents in context
for d in documents:
    index.insert(document=d, storage_context=storage_context)

# saves the context in a storage, for later use in query_data.py
index.storage_context.persist("storageExample")

