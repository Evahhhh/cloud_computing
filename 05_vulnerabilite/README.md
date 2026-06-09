# Vulnerabilites S3 identifiees

Ce projet deploie volontairement un bucket non securise pour illustrer les failles courantes.

## Failles du bucket vulnerable

1. **Public Access Block manquant** → tout internet peut acceder au bucket
2. **ACL public-read** → les fichiers sont lisibles sans credentials
3. **Bucket Policy trop permissive (Principal: \*)** → listage et lecture libres
4. **Chiffrement absent** → donnees en clair dans les data centers
5. **Versioning absent** → suppression accidentelle ou malveillante irreversible
6. **Logging absent** → aucune trace des acces, impossible d'auditer une intrusion

## Corrections appliquees dans bucket_securise.tf

- `aws_s3_bucket_public_access_block` avec tous les flags a `true`
- Chiffrement AES-256 par defaut
- Versioning active
