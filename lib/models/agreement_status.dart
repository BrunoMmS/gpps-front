enum AgreementStatus { PENDING, APPROVED, REJECTED, EXPIRED }

AgreementStatus fromString(String status) {
  switch (status.toUpperCase()) {
    case 'PENDING':
      return AgreementStatus.PENDING;
    case 'APPROVED':
      return AgreementStatus.APPROVED;
    case 'REJECTED':
      return AgreementStatus.REJECTED;
    case 'EXPIRED':
      return AgreementStatus.EXPIRED;
    default:
      throw ArgumentError('Unknown agreement status: $status');
  }
}


