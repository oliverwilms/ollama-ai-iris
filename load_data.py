import os
from dotenv import load_dotenv
from llama_index.core import SimpleDirectoryReader,StorageContext,VectorStoreIndex
from llama_iris import IRISVectorStore

url = f"iris://teste:teste@localhost:51774/TESTE"

documents = SimpleDirectoryReader("data_example").load_data()
print("Document ID:", documents[0].doc_id)

from llama_index.core import Settings
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.huggingface import HuggingFaceEmbedding
from llama_index.core import StorageContext, load_index_from_storage

Settings.embed_model = HuggingFaceEmbedding(model_name="BAAI/bge-m3")
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
query_engine = index.as_query_engine()

for d in documents:
    index.insert(document=d, storage_context=storage_context)

#saves the context in a storage, for later use in query_data.py
index.storage_context.persist("storageExample")

