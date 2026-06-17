package com.papercraft.model.enums;

public enum VerificationStatus {
        VERIFIED("Hợp lệ (An toàn)", "status-verified"),
        TAMPERED("Dữ liệu DB đã bị thay đổi / Cần ký lại", "status-tampered"),
        INVALID_SIGNATURE("Chữ ký không hợp lệ", "status-invalid"),
        UNSIGNED("Đơn hàng chưa ký", "status-unsigned"),
        KEY_REVOKED_BUT_VALID("Khóa đã báo mất (Chữ ký gốc hợp lệ)", "status-revoked-valid");

        private final String displayName;
        private final String cssClass;

        VerificationStatus(String displayName, String cssClass) {
            this.displayName = displayName;
            this.cssClass = cssClass;
        }

        public String getDisplayName() { return displayName; }
        public String getCssClass() { return cssClass; }
    }