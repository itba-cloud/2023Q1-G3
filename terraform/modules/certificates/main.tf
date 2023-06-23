# IMPORTANTE: si quieren levantar la arquitectura, necesitamos incluir los NS de su hosted zone
# en la configuración de nuestro dominio para que levante el ACM,
# avisen por mail con los NS de su hosted zone para que
# los incluyamos en nuestra administración de dominio. De todos modos dejamos screenshots en el
# readme mostrando que compramos el dominio y le asignamos un certificado con ACM usando terraform.

#pedir el certificado
resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"

   lifecycle {
    create_before_destroy = true
  }
}

#record set de r53 para validacion de dominio
resource "aws_route53_record" "this" {
  for_each = {
    for domain_validation_object in aws_acm_certificate.this.domain_validation_options : domain_validation_object.domain_name => {
      name    = domain_validation_object.resource_record_name
      record  = domain_validation_object.resource_record_value
      type    = domain_validation_object.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this.zone_id
}

#validar certificado acm
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this : record.fqdn]
}
