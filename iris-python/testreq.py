import chardet
import json
import logging
import re
from requests import Request, Session

logger = logging.getLogger(__name__)
logging.basicConfig(filename='testreq.log', encoding='utf-8', level=logging.DEBUG)

def read_file(file_path: str):
    """
    Read some text from a text file.
    """
    logger.debug(file_path)
    with open(file_path, "rb") as f:
        file_data = f.read()
        encoding = chardet.detect(file_data).get("encoding")
        file_data = file_data.decode(encoding)
        original_string = file_data.replace("\n", " ")
        modified_string = re.sub(r'"', "'", original_string)
        return modified_string

def req_data(prompt_path: str):
    prompt_data = read_file(prompt_path)
    print({prompt_data})
    question_path = "/irisdev/app/data/prompts/medical_progress_notes_prompt.txt"
    question_data = read_file(question_path)
    print(question_data)
    data = '{"model": "llama3.2", "messages": [{"role": "system", "content": "$question"}, {"role": "user", "content": "$prompt"}]}'
    data1 = data.replace("$question",question_data)
    data2 = data1.replace("$prompt",prompt_data)
    print(data2)
    logger.debug(data2)
    return data2

def send_chat(prompt_path: str, url: str):
    data2 = req_data(prompt_path)
    s = Session()
    
    req = Request('POST', url, data=data2,)
    #prepped = req.prepare()
    prepped = s.prepare_request(req)
    # Merge environment settings into session
    settings = s.merge_environment_settings(prepped.url, {}, None, None, None)
    # do something with prepped.body
    # prepped.body = '{"model": "llama3.2", "messages": [{"role": "system", "content": "$question"}, {"role": "user", "content": "$prompt"}]}'
    prepped.body = data2
    # do something with prepped.headers
    #del prepped.headers['Content-Type']
    #r = s.send(prepped, **settings)
    timeout = 300
    resp = s.send(prepped,
        stream=False,
        timeout=timeout
    )
    answer = []
    #for line in r.iter_lines():
    for line in resp.iter_lines():
        # filter out keep-alive new lines
        if line:
            logger.debug(line)
            result = chardet.detect(line)
            encoding = result['encoding']
            try:
                decoded_line = line.decode(encoding)
            except UnicodeDecodeError:
                decoded_line = line.decode(encoding, errors="ignore")
            y = (json.loads(decoded_line))
            message = y["message"]
            content = message["content"]
            answer.append(content)
    print(str(answer))
    return str(answer)

def send_chat_iris(prompt_path: str):
    url = "http://localhost:53795/api/test/Service"
    answer = send_chat(prompt_path, url)
    return answer

def send_chat_ollama(prompt_path: str):
    url = "http://ollama:11434/api/chat"
    answer = send_chat(prompt_path, url)
    return answer
