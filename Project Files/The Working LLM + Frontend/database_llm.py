import os
import re
from fastapi import FastAPI
from pydantic import BaseModel
from llama_cpp import Llama
import paramiko

class QueryPayload(BaseModel):
    query: str
    netid: str
    password: str

app = FastAPI()

def run_query_on_ilab(sql: str, username: str, password: str, hostname: str = "ilab.cs.rutgers.edu"):
    """
    Execute a SQL query on the ilab server via SSH and return the output or error.
    """
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(hostname, username=username, password=password)

        command = f'python3 ilab_script.py "{sql}" {username} {password}'
        stdin, stdout, stderr = client.exec_command(command, get_pty=True)
        stdin.close()

        stdout.channel.settimeout(30)
        output = stdout.read().decode("utf-8", errors="ignore")
        error = stderr.read().decode("utf-8", errors="ignore")

        client.close()
        if error:
            return {"error": error.strip()}
        return {"output": output.strip() or "<no output>"}
    except Exception as e:
        return {"error": str(e).strip()}


def load_llm():
    model_path = "/common/home/jfs199/Desktop/Project02/Phi-3.5-mini-instruct-Q4_K_M.gguf"
    if not os.path.exists(model_path):
        raise ValueError(f"Model path does not exist: {model_path}")
    return Llama(model_path=model_path, n_ctx=2048, n_threads=4)

llm = load_llm()


def run_inference(nl_query: str, username: str, password: str):
    # Build prompt
    prompt = f"""### Database Schema
AgencyMap(agency_code, agency_name, agency_abbr)
LoanTypeMap(loan_type, loan_type_name)
Application(agency_code, loan_type, application_id, applicant_income_000s, loan_amount_000s)

### Task
Translate the following natural-language request into a SQL query.
**Only** output the plain SQL query, starting with SELECT, WITH, INSERT, UPDATE, or DELETE.
**Do NOT** wrap it in Markdown code fences.

Request: {nl_query}

SQL query:"""

    # Get raw LLM output
    response = llm(prompt=prompt, max_tokens=512, temperature=0.0)
    raw = response["choices"][0]["text"]

    # Normalize and strip fences
    raw_stripped = raw.strip()
    # Remove backtick fences
    if raw_stripped.startswith("```"):
        parts = raw_stripped.split("```")
        if len(parts) >= 3:
            raw_stripped = parts[1]
    # Remove triple-quote fences
    if raw_stripped.startswith("'''") and raw_stripped.endswith("'''"):
        raw_stripped = raw_stripped[3:-3]
    elif raw_stripped.startswith('"""') and raw_stripped.endswith('"""'):
        raw_stripped = raw_stripped[3:-3]
    raw_stripped = raw_stripped.strip()

    # Split lines and find start of SQL block
    lines = raw_stripped.splitlines()
    start_idx = next((i for i, line in enumerate(lines)
                      if line.strip().upper().startswith(("SELECT", "WITH", "INSERT", "UPDATE", "DELETE"))), None)
    if start_idx is not None:
        # Take all lines from the first SQL keyword onward
        sql_query = "\n".join(lines[start_idx:]).strip()
    else:
        sql_query = raw_stripped  # fallback to entire output

    # Execute remotely
    result = run_query_on_ilab(sql_query, username, password)
    return {
        "originalQuery": nl_query,
        "sqlQuery": sql_query,
        "result": result
    }


@app.post("/query")
async def handle_query(payload: QueryPayload):
    return run_inference(payload.query, payload.netid, payload.password)


if __name__ == "__main__":
    while True:
        inp = input("ASK A PROMPT (or 'exit' to quit): ").strip()
        if inp.lower() in ("exit", "quit"): break
        netid = input("NetID: ").strip()
        pwd = input("Password: ").strip()
        resp = run_inference(inp, netid, pwd)
        print("--- Original Query ---", resp["originalQuery"])
        print("--- SQL Query ---\n", resp["sqlQuery"])
        print("--- Result ---", resp["result"])

