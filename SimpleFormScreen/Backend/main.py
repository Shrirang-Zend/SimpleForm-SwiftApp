#  uvicorn main:app --reload
#  main.py
#  SimpleFormScreen

#  Created by Shrirang Zend on 07/03/25.


from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr
from typing import Literal, Optional
from datetime import date

app = FastAPI()

class FormData(BaseModel):
    fullName: str
    email: EmailStr
    password: str
    dateOfBirth: date
    gender: Literal["Male", "Female", "Other"]
    numPets: int = 0
    monthlySpending: float = 0.0
    age: Optional[int] = None
    satisfaction: Optional[float] = None  
    accountType: Literal["Basic", "Premium", "Enterprise"]
    bio: str = ""
    termsAccepted: bool

@app.post("/submit")
async def submit_form(data: FormData):
    if not data.termsAccepted:
        raise HTTPException(status_code=400, detail="You must accept the terms.")
    
    print(f"Received form submission: {data}")
    return {"message": "Form submitted successfully!"}
