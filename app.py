from fastapi import FastAPI, UploadFile
from ultralytics import YOLO
import cv2
import numpy as np

app = FastAPI()

model = YOLO("best.pt")  # model must be inside the same folder

@app.post("/predict")
async def predict(file: UploadFile):
    image_bytes = await file.read()
    np_img = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

    results = model(img)[0]

    predictions = []
    for box in results.boxes:
        predictions.append({
            "class_id": int(box.cls),
            "confidence": float(box.conf),
            "xmin": float(box.xyxy[0][0]),
            "ymin": float(box.xyxy[0][1]),
            "xmax": float(box.xyxy[0][2]),
            "ymax": float(box.xyxy[0][3])
        })

    return {
        "num_predictions": len(predictions),
        "predictions": predictions
    }
