import os, time, random, json, codecs, sys
from openai import OpenAI

client = OpenAI(api_key="sk-proj-qlgDp6WBcaaGXYrc1IJeT3BlbkFJUosuNsTcSO0Z13w2PQzN")

MODEL = "gpt-3.5-turbo"

def answer(query):
    persona = "You are a senior smart contract developer and understand security vulnerabilities well."

    try:
        response = client.chat.completions.create(
            messages=[
                {"role": "system", "content": persona},
                {"role": "user", "content": query},
            ],
            model=MODEL,
            temperature=0.7,
        )
        return response
    except Exception as e:
        print(f"Error querying: {e}")
        return {}


def build_query_from_template(name: str, description_path: str) -> str:
    TEMPLATE = "prompt.md";
    
    # Get the description
    with open(description_path, "r", encoding="utf-8") as f:
        description = f.read()

    # Build query
    with open(TEMPLATE, "r", encoding="utf-8") as f:
        prompt = f.read()
        query = prompt.replace("{{ concept_of_contract }}", name).replace("{{ detail_specifications }}", description)

    return query

def send_query(query: str) -> dict:
    res = answer(query)
    res = json.loads(res.model_dump_json())
    res["query"] = query
    return res


CONTRACTS: dict = {
    "DiceGame": {
        "name": "Dice Game",
        "description_path": "contracts/DiceGame/DiceGame.md"
    },
    "DecentralizedExchange": {
        "name": "DecentralizedExchange",
        "description_path": "contracts/DecentralizedExchange/DecentralizedExchange.md"
    },
    "TokenVendor": {
        "name": "TokenVendor",
        "description_path": "contracts/TokenVendor/TokenVendor.md"
    },
    "Staker": {
        "name": "Staker",
        "description_path": "contracts/Staker/Staker.md"
    }
}

if __name__ == "__main__":
    # Loop over contracts
    for contract_id, contract in CONTRACTS.items():
        name, description_path = contract["name"], contract["description_path"]
        directory = os.path.dirname(description_path)

        # Check if the generated file exists, if it is, bail out
        if os.path.exists(f"{directory}/{contract_id}.generated.sol"):
            print(f"Skipping {name}")
            continue

        # Build query
        query = build_query_from_template(name, description_path)
        res = send_query(query)

        # Write output to file
        with open(f"{directory}/{contract_id}.json", "w") as f:
            json.dump(res, f, ensure_ascii=False, indent=2)

        # Write content (contract)
        if "choices" in res and len(res["choices"]) > 0:
            with open(f"{directory}/{contract_id}.generated.sol", "w") as f:
                f.write(res["choices"][0]["message"]["content"])

        time.sleep(1)


