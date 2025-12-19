import '../models/news_article.dart';

/// Mock data cho ứng dụng tin tức
class MockData {
  static final List<NewsArticle> articles = [
    NewsArticle(
      id: '1',
      title: 'AI đang thay đổi cách chúng ta làm việc như thế nào trong kỷ nguyên số?',
      content: '''Trí tuệ nhân tạo (AI) không còn là những câu chuyện viễn tưởng trong phim ảnh. Nó đã len lỏi vào từng ngóc ngách của đời sống công sở, từ việc tự động hóa email cho đến phân tích dữ liệu phức tạp chỉ trong vài giây.

Các công cụ như ChatGPT hay Midjourney đang định nghĩa lại khái niệm "sáng tạo". Thay vì lo sợ bị thay thế, chúng ta nên học cách làm chủ công nghệ để tối ưu hóa hiệu suất làm việc.

"AI sẽ không thay thế con người. Nhưng người biết sử dụng AI sẽ thay thế người không biết."

Không chỉ dừng lại ở các tác vụ kỹ thuật, AI còn đang hỗ trợ bộ phận nhân sự trong việc tuyển dụng, sàng lọc hồ sơ và thậm chí là đánh giá năng lực nhân viên một cách khách quan hơn. Điều này đặt ra câu hỏi lớn về tính đạo đức và sự công bằng trong thuật toán.

Tuy nhiên, yếu tố con người - sự đồng cảm, khả năng phán đoán tình huống và tư duy chiến lược - vẫn là những thứ mà máy móc chưa thể sao chép được.''',
      excerpt: 'Trí tuệ nhân tạo đang thay đổi cách chúng ta làm việc, từ tự động hóa đến phân tích dữ liệu.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBE8kneMCH_N_9tKwte_MSgmrLU2RDVfeT-b3cOduEt9-YctZmRfkV72eTj_Yl_T66iaIz9yyadGP6x_XhyVUmnXwAFvbBu3SiJoDCQV4zDGPXWiKZcxzAu2MXIKbduup2AoJAh-E0uOR1a_GExbMh_8lYo-Cg42NrmICW3KThPzSIE4Fk_LfZ3Vrv9zc8u5EcXX299isqgyKonR1vTpJtNtxrKu_bCT0Z8GAUKImCd9lsnY8nWGt5Pg8gx-SGIhBeZHDKQJbMYmmbF',
      category: 'CÔNG NGHỆ',
      author: 'Nguyễn Văn A',
      authorAvatar: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCoqrHhhMGdZnV2LIAz2uEXDBE98DJGAsVL3BiSrUd2An3hZYkt6ZKF22DVI0BBS35EeCTIk9m39FV6lO3Xbx7CwsW7VrMe1kBj1Le1B9sse9hkBlo70QoxSy8zwfbNXf8pszmSz--Gj82m6JGOWlIPuaqicH2ZrxOgiXauuCalSqzEuNmyFazY_3CoKgEjy1ZU3bOgQnNV6oT1sFkJTX6jLsrDxqEgbBGlUikDNTWlhl31goC23wP6AK3c8Pr1-HDPS-xDIwazswwP',
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      readTimeMinutes: 5,
      viewCount: 12500,
      isFeatured: true,
      isHot: false,
      videoUrl: 'https://example.com/video1.mp4',
      videoDuration: '04:32',
      tags: ['AI', 'Công nghệ', 'Tương lai'],
    ),
    NewsArticle(
      id: '2',
      title: 'Siêu bão Noru đang tiến vào biển Đông với sức gió giật cấp 17',
      content: 'Siêu bão Noru đang di chuyển với tốc độ nhanh về phía biển Đông, dự kiến sẽ ảnh hưởng trực tiếp đến các tỉnh miền Trung trong 24-48 giờ tới.',
      excerpt: 'Siêu bão Noru đang tiến vào biển Đông với cường độ mạnh.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBNPhObyMdGE9UGtPOZ-oHU0yet4I8K5Fed4Vy6CgAR22xMc6iJqMCyRz3HUOS2lCWBWpUrFnK6S_vxUWFHF8JHerxC03f0UG-KogvL0Y2OzB_U6Nx7_ywSG8IiENbX9J1e77GKVfFKJs-EB7FUgsnvQbrNInsJbF_4n4c3fq56QK2I_0K5uI6DK7PsB0DRKmznQekbu3JvmDIWk7IGh8qJwwB8bCZO-BLRusgNFpeK_NBmjrh6ZXBfZnybsC9Dc1guPCc7WWv71bSt',
      category: 'THỜI SỰ',
      author: 'VnExpress',
      authorAvatar: 'https://via.placeholder.com/150',
      publishedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      readTimeMinutes: 3,
      viewCount: 45000,
      isFeatured: true,
      isHot: true,
      tags: ['Thời tiết', 'Bão'],
    ),
    NewsArticle(
      id: '3',
      title: 'iPhone 15 chính thức ra mắt: USB-C, khung Titan, giá không đổi',
      content: 'Apple vừa công bố dòng iPhone 15 series với nhiều nâng cấp đáng chú ý, đặc biệt là chuyển sang cổng USB-C.',
      excerpt: 'iPhone 15 ra mắt với USB-C và nhiều cải tiến.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCAkezxm2_bkqfM3phJXV0M_r7raU0dT9KfyBE9DbOKlidRF-LSGsaNzke_DhU5FGG6WNHZXx9vfWzHiRJSLOtWVUyOocFZqd2XnGUlRkLSBKRze_uujkSaZFTeVMQkIleL3gRnJpT2Nj4k1vg9LerJUdmoTZH29-wNmNH54o2llwMLrE_iUt6Dt_LCmFQ0yHOcySquwgCL1w7x4q7QFlDycJeAFGbnc9ejmCo6itvxXQKc4lLj2rrQtW1V0fqAMFeYromxGU0MwRAr',
      category: 'CÔNG NGHỆ',
      author: 'TinhTe',
      authorAvatar: 'https://via.placeholder.com/150',
      publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
      readTimeMinutes: 4,
      viewCount: 32000,
      isFeatured: true,
      isHot: false,
      tags: ['Apple', 'iPhone', 'Smartphone'],
    ),
    NewsArticle(
      id: '4',
      title: 'Thị trường chứng khoán hôm nay: VN-Index hồi phục mạnh mẽ nhờ nhóm ngân hàng',
      content: 'VN-Index đã có phiên tăng điểm ấn tượng, được hỗ trợ mạnh mẽ từ nhóm cổ phiếu ngân hàng và chứng khoán.',
      excerpt: 'VN-Index tăng mạnh nhờ nhóm cổ phiếu ngân hàng.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAuUuz0G8Y9NLin1pJ48ylVFeIIg9W4IFqC0oGqAiDukMT6XKTCpqnFGMblnSX_NCQRddGxR7phxHi7RfYzsvgVw-dazMvdwCvVJpGGqdCf1vfYVLcK4TPZH9Bu2nL4WjDI3hhszrNxVkIkexnq234DO5hLUtzanPEuLfNdZfa07RD8mANzZI85LtJ3lYMaeUwElNqfb0HidNl-NftjOogt6h5nUBbTYCTw0ObB9LC-puJsR2Ez7SgVZbS20O1ppDMo1MiftgKk9oqB',
      category: 'KINH TẾ',
      author: 'ZingNews',
      authorAvatar: 'https://via.placeholder.com/150',
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      readTimeMinutes: 3,
      viewCount: 8200,
      tags: ['Chứng khoán', 'VN-Index'],
    ),
    NewsArticle(
      id: '5',
      title: 'VinFast xuất khẩu lô xe điện VF8 tiếp theo sang thị trường Bắc Mỹ',
      content: 'VinFast tiếp tục chiến lược mở rộng thị trường quốc tế với lô xe VF8 mới được xuất sang Mỹ và Canada.',
      excerpt: 'VinFast xuất khẩu VF8 sang Bắc Mỹ.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD-IRNVDkAdbgXbaWGnJT3rwi6gqhJHKv7bY8WPb14qFRnPM_5cBREtOTfrXvUpP0dtlKrIc-yS9j4wOqudLOjsmTU_zmXqUukLVYENdyaAxuDG13waRFLp-KnoK-9w9IpXzzBoPh79k7DRMydIWmGLgNFD35h7qf9uHCpk3bIWhE-yn7G5sTtX098CwI3O5hWLyP5OTZ_RF9bC28DS4opt7NxhD-2z4zM3EcZ30S_FUMt8ucauxc7ZOJf1hd7TrMTbYZQtCa-26iFv',
      category: 'KINH DOANH',
      author: 'CafeF',
      authorAvatar: 'https://via.placeholder.com/150',
      publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
      readTimeMinutes: 4,
      viewCount: 15000,
      tags: ['VinFast', 'Ô tô điện'],
    ),
    NewsArticle(
      id: '6',
      title: 'Kết quả Ngoại hạng Anh: Man City thắng đậm, Arsenal giữ vững ngôi đầu',
      content: 'Trong trận đấu thuộc vòng 10 Ngoại hạng Anh, Man City đã có chiến thắng thuyết phục với tỷ số 5-1.',
      excerpt: 'Man City thắng đậm trong trận cầu vòng 10 Premier League.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA8CDlEaM3jiU3ySMRN1GO0g7RizatBrHz9-tAHuvnHSwc3ALx78Df1Um73VfyG23F47gYcKKFLcw9ghH9ysIWqBONMMfIL8P1qUFFQcwqx6a1F5KEZmmoRNuU33poll-pYytPdciduvqoQfZHZKNec1ITubSERk-zr0vumQ1i3oZ_QYR8cjTUH8giFHi9q_RfeQOX0R3CJ2N9bAhH9JGhnmVPiLzDtg6eJV3SvfzofLYCqGECdIk3Zvwc90pEeqtw4uxiSjkbA2n7b',
      category: 'THỂ THAO',
      author: 'VietnamNet',
      authorAvatar: 'https://via.placeholder.com/150',
      publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
      readTimeMinutes: 2,
      viewCount: 28000,
      tags: ['Bóng đá', 'Premier League'],
    ),
    NewsArticle(
      id: '7',
      title: 'Triển lãm nghệ thuật đương đại "Dòng Chảy" thu hút giới trẻ Sài Gòn',
      content: 'Triển lãm nghệ thuật đương đại với nhiều tác phẩm độc đáo đang được tổ chức tại TPHCM.',
      excerpt: 'Triển lãm "Dòng Chảy" gây ấn tượng với giới trẻ.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDflUPPvLE-S_jMF9q353upm9sF2EM3neboTMxFW5-uVabngaapXE-rs_4AGpMskxcY1b8tRTXRzdJb6RdOmVfPMe8HQvIecZkdH67CQSo1wG0eJFfMlxPEL2FmLfsAr8bVDmrssIsM6_KwRi8skBpr6Mi9SuLK7M7mhqRuIBGF7caSr3-QZ9bTWJJICvAJI_IcxSY0RwbAd5jwm00l8fuAQ8UfTF6nwyxeroJNPovqtrYjQcCMkcLKYSqbF_iyIHN_8sHlYUi3WgfU',
      category: 'ĐỜI SỐNG',
      author: 'Kenh14',
      authorAvatar: 'https://via.placeholder.com/150',
      publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
      readTimeMinutes: 3,
      viewCount: 5400,
      tags: ['Nghệ thuật', 'Sài Gòn'],
    ),
    NewsArticle(
      id: '8',
      title: 'Meta ra mắt tính năng AI mới, thay đổi cách chúng ta tương tác mạng xã hội',
      content: 'Meta công bố tính năng AI mới giúp tối ưu hóa trải nghiệm người dùng trên các nền tảng mạng xã hội.',
      excerpt: 'Meta giới thiệu AI mới cho mạng xã hội.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCGMOfzRUdoJ6I37fYWt5T87J-3Hz1TQsVKzVOoYgNOe7aBH656BTqorvZCyyBgL1iYnxSfi58GW5pXghxoOgP_fz3N1oRh759OpvzoQA7zDBrt_Khny1-fwfp708kt_TRLJfoSP-VwCXQGO79odtj3nPgjPGZzvPCwySptFDG40JKI_DT73b3yh_2RyrQnueXZkzZGBvtLhHqPa_rD0mvHuiKNOfDWHHUUErWiH02ZXAMXFlPDu-weLyUYuQm2HUaihLFtOZBpS_xG',
      category: 'CÔNG NGHỆ',
      author: 'TechCrunch',
      authorAvatar: 'https://via.placeholder.com/150',
      publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      readTimeMinutes: 4,
      viewCount: 12500,
      tags: ['Meta', 'AI', 'Social Media'],
    ),
  ];

  // Lấy bài viết featured
  static List<NewsArticle> get featuredArticles {
    return articles.where((article) => article.isFeatured).toList();
  }

  // Lấy bài viết theo category
  static List<NewsArticle> getArticlesByCategory(String category) {
    if (category.toLowerCase() == 'all' || category.toLowerCase() == 'tất cả') {
      return articles;
    }
    return articles
        .where((article) => article.category.toLowerCase().contains(category.toLowerCase()))
        .toList();
  }

  // Tìm kiếm bài viết
  static List<NewsArticle> searchArticles(String query) {
    if (query.isEmpty) return articles;
    
    final lowerQuery = query.toLowerCase();
    return articles.where((article) {
      return article.title.toLowerCase().contains(lowerQuery) ||
          article.content.toLowerCase().contains(lowerQuery) ||
          article.category.toLowerCase().contains(lowerQuery) ||
          article.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Lấy bài viết liên quan
  static List<NewsArticle> getRelatedArticles(NewsArticle article, {int limit = 3}) {
    return articles
        .where((a) => 
            a.id != article.id && 
            (a.category == article.category || 
             a.tags.any((tag) => article.tags.contains(tag))))
        .take(limit)
        .toList();
  }
}

