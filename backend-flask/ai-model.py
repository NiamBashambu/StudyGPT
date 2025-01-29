from openai import OpenAI
from flask import Flask, request, jsonify
from flask_cors import CORS
import os
import re
import json
from dotenv import load_dotenv
load_dotenv()


app = Flask(__name__)
CORS(app)

# Set your OpenAI API key here from environment variables
api_key = os.getenv('OPENAI_API_KEY')  # Ensure your API key is set as an environment variable
if not api_key:
    raise ValueError("API key not found. Please set the OPENAI_API_KEY environment variable.")

# Initialize the OpenAI client with the API key
client = OpenAI(api_key=api_key)

# Function to generate a study plan using GPT-4
def generate_study_plan_gpt(assignment_title, due_date, assignment_type, content):
    messages = [
        {"role": "user", "content": f"I have an assignment titled '{assignment_title}', which is a {assignment_type}. "
                                     f"The due date is {due_date}. The assignment content is: {content}. "
                                     f"Can you create a study plan that outlines tasks but includes no dates? Your token limit is 300."}
    ]

    try:
        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=messages,
            max_tokens=300,
            temperature=0.4
        )

        if response.choices:
            # Directly return the raw response from GPT-4
            study_plan = response.choices[0].message.content.strip()
            return study_plan  # No task extraction, just return the response as is

        else:
            return "No response from the model."

    except Exception as e:
        print("Error:", e)
        return f"Error: {e}"
# Endpoint to generate study plan based on assignments
@app.route('/generate-plan', methods=['POST'])
def generate_plan():
    data = request.json
    assignments = data.get('assignments', [])

    study_plans = []

    if not isinstance(assignments, list):
        return jsonify({"error": "Invalid format: assignments should be a list."}), 400

    for assignment in assignments:
        title = assignment.get('title')
        due_date = assignment.get('dueDate')
        assignment_type = assignment.get('type')
        content = assignment.get('content')
        
        gpt_study_plan = generate_study_plan_gpt(title, due_date, assignment_type, content)
        
        # Check if the plan returned is a list
        if not isinstance(gpt_study_plan, list):
            gpt_study_plan = [gpt_study_plan]  # Ensure it's a list even if an error occurs

        study_plans.append({
            "title": title,
            "studyPlan": gpt_study_plan,  # Should be an array of strings
            "dueDate": due_date,
            "type": assignment_type
        })

    return jsonify(study_plans)  # Return as a JSON response

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))  
    app.run(host='0.0.0.0', port=port)