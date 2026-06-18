package com.papercraft.model.enums;

public enum NotificationType {
    ORDER_PENDING("Đơn hàng đang chờ", "Đơn hàng #%d đang chờ xử lý.", "order-view?orderId=%d"),
    ORDER_SHIPPED("Đơn hàng đang được giao", "Đơn hàng #%d đang được giao.", "order-view?orderId=%d"),
    ORDER_COMPLETED("Đơn hàng đã giao thành công", "Đơn hàng #%d đã được giao thành công.", "order-view?orderId=%d"),
    ORDER_CANCELLED("Đơn hàng đã bị hủy", "Đơn hàng #%d đã bị hủy.", "order-view?orderId=%d"),

    BLOG_SUBMITTED("Blog đã được gửi", "Blog của bạn đã được gửi và đang chờ duyệt.", "blog"),
    BLOG_APPROVED("Blog đã được duyệt", "Blog #%d đã được duyệt và hiển thị công khai.", "blog-post?id=%d"),
    BLOG_HIDDEN("Blog bị ẩn", "Blog của bạn đã bị ẩn.", "blog"),
    BLOG_DELETED("Blog bị xóa", "Blog của bạn đã bị xóa.", "blog"),

    CONTACT_SUBMITTED("Liên hệ đã được gửi", "Yêu cầu liên hệ của bạn đã được gửi thành công.", "contact"),
    CONTACT_REPLIED("Liên hệ đã được phản hồi", "Yêu cầu liên hệ của bạn đã được phản hồi.Vui lòng kiểm tra email!", "contact"),

    PASSWORD_CHANGED("Mật khẩu đã được thay đổi", "Mật khẩu tài khoản của bạn đã được thay đổi thành công.", "change-password"),

    VOUCHER("Khuyến mãi mới", "Có chương trình khuyến mãi mới dành cho bạn.", "voucher"),

    // ATBM
    ORDER_TAMPERED("Đơn hàng bị cảnh báo bảo mật", "Đơn hàng #%d của bạn đã bị thay đổi dữ liệu trái phép. Vui lòng ký lại đơn hàng để đảm bảo tính pháp lý.", "order-view?orderId=%d"),
    KEY_REVOKED("Báo mất khóa thành công", "Bạn đã báo mất khóa chữ ký số. Hệ thống yêu cầu bạn tạo và cập nhật khóa mới để ký các đơn hàng tiếp theo. Lưu ý: Các đơn hàng cũ đã ký xác thực trước thời điểm này vẫn HỢP LỆ và giữ nguyên giá trị pháp lý.", "key-management"),
    KEY_UPLOADED("Cập nhật khóa mới thành công", "Public Key mới của bạn đã được tải lên hệ thống an toàn. Bạn đã có thể sử dụng khóa (Private Key) mới này để ký xác thực cho các đơn mua hàng tiếp theo.", "key-management");

    private final String title;
    private final String contentTemplate;
    private final String routePattern;

    NotificationType(String title, String contentTemplate, String routePattern) {
        this.title = title;
        this.contentTemplate = contentTemplate;
        this.routePattern = routePattern;
    }

    public String getTitle() {
        return title;
    }

    public String getRoutePattern() {
        return routePattern;
    }

    public String getContentTemplate() {return contentTemplate;}


    public boolean requiresReferenceId() {
        return routePattern.contains("%d");
    }

}
