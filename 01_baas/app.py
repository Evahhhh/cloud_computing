# === app.py ===
import boto3
import uuid
from datetime import datetime

# Connexion LocalStack
config = dict(
    endpoint_url="http://localhost:4566",
    region_name="us-east-1",
    aws_access_key_id="test",
    aws_secret_access_key="test"
)

dynamo = boto3.resource("dynamodb", **config)
s3 = boto3.client("s3", **config)


def creer_utilisateur(nom, email):
    table = dynamo.Table("baas-users")
    user = {
        "userId": str(uuid.uuid4()),
        "nom": nom,
        "email": email,
        "creeA": datetime.now().isoformat()
    }
    table.put_item(Item=user)
    print(f"[BaaS] Utilisateur cree : {nom} ({user['userId'][:8]}...)")
    return user


def uploader_fichier(user_id, nom_fichier, contenu):
    cle = f"users/{user_id}/{nom_fichier}"
    s3.put_object(Bucket="baas-user-files", Key=cle, Body=contenu.encode())
    print(f"[BaaS] Fichier uploade : {cle}")


if __name__ == "__main__":
    u = creer_utilisateur("Alice Dupont", "alice@exemple.fr")
    uploader_fichier(u["userId"], "profil.txt", "Donnees profil Alice")
    print("[BaaS] Application BaaS operationnelle !")
