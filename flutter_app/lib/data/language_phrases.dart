// Enhanced emergency language phrases for travelers
// Supports Thai with practical daily expressions

class LanguagePhrase {
  final String id;           // 唯一标识，方便引用
  final String chinese;      // 中文释义
  final String thai;         // 泰语原文
  final String romanization; // 罗马音（发音提示）
  final String note;         // 使用提示（如敬语、性别差异等）

  const LanguagePhrase({
    required this.id,
    required this.chinese,
    required this.thai,
    required this.romanization,
    this.note = '',
  });
}

class LanguageScene {
  final String id;           // 场景唯一标识
  final String name;         // 场景中文名
  final String icon;         // 图标
  final String description;  // 场景简短描述
  final List<LanguagePhrase> phrases;

  const LanguageScene({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.phrases,
  });
}

// ======================== 泰语场景数据 ========================

const List<LanguageScene> thaiScenes = [
  // 1. 问候与礼仪（日常必备）
  LanguageScene(
    id: 'greeting',
    name: '问候与礼仪',
    icon: '🙏',
    description: '泰国人非常注重礼貌，句尾加ครับ(男)/ค่ะ(女)会让人好感倍增',
    phrases: [
      LanguagePhrase(
        id: 'hello',
        chinese: '你好 / 再见',
        thai: 'สวัสดี',
        romanization: 'sà-wàt-dii',
        note: '男性说 สวัสดีครับ (sà-wàt-dii kráp)；女性说 สวัสดีค่ะ (sà-wàt-dii kâ)',
      ),
      LanguagePhrase(
        id: 'thank_you',
        chinese: '谢谢',
        thai: 'ขอบคุณ',
        romanization: 'khòp-khun',
        note: '加敬语：ขอบคุณครับ/ค่ะ',
      ),
      LanguagePhrase(
        id: 'sorry',
        chinese: '对不起 / 抱歉',
        thai: 'ขอโทษ',
        romanization: 'khǒr-thôot',
        note: '口语也可用 โทษนะ (thôot ná)',
      ),
      LanguagePhrase(
        id: 'its_ok',
        chinese: '没关系',
        thai: 'ไม่เป็นไร',
        romanization: 'mâi-pen-rai',
        note: '非常常用的宽慰语',
      ),
      LanguagePhrase(
        id: 'excuse_me',
        chinese: '打扰一下 / 劳驾',
        thai: 'ขอโทษนะ',
        romanization: 'khǒr-thôot-ná',
        note: '问路或叫服务员时使用',
      ),
      LanguagePhrase(
        id: 'how_are_you',
        chinese: '你好吗？',
        thai: 'สบายดีไหม',
        romanization: 'sà-baai-dii-mǎi',
        note: '回答：สบายดี (sà-baai-dii) 我很好',
      ),
      LanguagePhrase(
        id: 'nice_to_meet',
        chinese: '很高兴认识你',
        thai: 'ยินดีที่ได้รู้จัก',
        romanization: 'yin-dii-thîi-dâi-rúu-jàk',
        note: '正式场合或初次见面使用',
      ),
    ],
  ),

  // 2. 问路与方向
  LanguageScene(
    id: 'directions',
    name: '问路与方向',
    icon: '🗺️',
    description: '泰国的街道有时没有英文标识，学会这些词很有用',
    phrases: [
      LanguagePhrase(
        id: 'where_is',
        chinese: '请问...在哪里？',
        thai: '... อยู่ที่ไหน',
        romanization: '... yùu-thîi-nǎi',
        note: '例如：洗手间在哪里？ห้องน้ำอยู่ที่ไหน (hông-náam yùu-thîi-nǎi)',
      ),
      LanguagePhrase(
        id: 'how_to_go',
        chinese: '去...怎么走？',
        thai: 'ไป ... ยังไง',
        romanization: 'bpai ... yang-ngai',
        note: '也可用 ไป...อย่างไร (bpai ... yàang-rai)',
      ),
      LanguagePhrase(
        id: 'go_straight',
        chinese: '直走',
        thai: 'ตรงไป',
        romanization: 'trong-bpai',
        note: '',
      ),
      LanguagePhrase(
        id: 'turn_left',
        chinese: '左转',
        thai: 'เลี้ยวซ้าย',
        romanization: 'líeow-sáai',
        note: '',
      ),
      LanguagePhrase(
        id: 'turn_right',
        chinese: '右转',
        thai: 'เลี้ยวขวา',
        romanization: 'líeow-kwǎa',
        note: '',
      ),
      LanguagePhrase(
        id: 'nearby',
        chinese: '附近',
        thai: 'ใกล้ๆ',
        romanization: 'klâi-klâi',
        note: '',
      ),
      LanguagePhrase(
        id: 'here_there',
        chinese: '这里 / 那里',
        thai: 'ที่นี่ / ที่นั่น',
        romanization: 'thîi-nîi / thîi-nân',
        note: '',
      ),
      LanguagePhrase(
        id: 'intersection',
        chinese: '十字路口',
        thai: 'สี่แยก',
        romanization: 'sìi-yaêk',
        note: '',
      ),
    ],
  ),

  // 3. 点餐（必学技能）
  LanguageScene(
    id: 'ordering',
    name: '点餐',
    icon: '🍜',
    description: '泰国美食不可错过，学会点菜和调整口味',
    phrases: [
      LanguagePhrase(
        id: 'menu',
        chinese: '请给我菜单',
        thai: 'ขอเมนูหน่อย',
        romanization: 'khǒr mee-nuu nòi',
        note: '也可直接说 “เมนู” (mee-nuu)',
      ),
      LanguagePhrase(
        id: 'what_is_this',
        chinese: '这个是什么？',
        thai: 'นี่คืออะไร',
        romanization: 'nîi-khuue-à-rai',
        note: '',
      ),
      LanguagePhrase(
        id: 'want_this',
        chinese: '我要这个',
        thai: 'เอาอันนี้',
        romanization: 'ao-an-nîi',
        note: '点餐时用手指着说最有效',
      ),
      LanguagePhrase(
        id: 'no_spicy',
        chinese: '不要辣',
        thai: 'ไม่เผ็ด',
        romanization: 'mâi-pèt',
        note: '泰国菜默认辣，一定要强调',
      ),
      LanguagePhrase(
        id: 'less_spicy',
        chinese: '少辣',
        thai: 'เผ็ดน้อย',
        romanization: 'pèt-nói',
        note: '',
      ),
      LanguagePhrase(
        id: 'no_sugar',
        chinese: '不要糖',
        thai: 'ไม่เอาน้ำตาล',
        romanization: 'mâi-ao-náam-taan',
        note: '饮料或甜品常用',
      ),
      LanguagePhrase(
        id: 'delicious',
        chinese: '好吃！',
        thai: 'อร่อย',
        romanization: 'a-ròi',
        note: '可以加重说 อร่อยมาก (a-ròi mâak) 非常好吃',
      ),
      LanguagePhrase(
        id: 'check_bill',
        chinese: '买单',
        thai: 'เก็บเงิน',
        romanization: 'gèp-ngern',
        note: '也可说 เช็คบิล (chék-bin) 或 ขอบิล (khǒr bin)',
      ),
      LanguagePhrase(
        id: 'takeaway',
        chinese: '打包',
        thai: 'ใส่ถุง',
        romanization: 'sài-thǔng',
        note: '也可以说 เอากลับบ้าน (ao-glàp-bâan)',
      ),
    ],
  ),

  // 4. 购物与砍价
  LanguageScene(
    id: 'shopping',
    name: '购物',
    icon: '🛒',
    description: '夜市和集市一定要砍价，学会这些能省不少钱',
    phrases: [
      LanguagePhrase(
        id: 'how_much',
        chinese: '多少钱？',
        thai: 'เท่าไหร่',
        romanization: 'thâo-rài',
        note: '',
      ),
      LanguagePhrase(
        id: 'too_expensive',
        chinese: '太贵了',
        thai: 'แพงไป',
        romanization: 'phaeng-bpai',
        note: '也可说 แพงเกินไป (phaeng-geern-bpai)',
      ),
      LanguagePhrase(
        id: 'discount',
        chinese: '能便宜点吗？',
        thai: 'ลดหน่อยได้ไหม',
        romanization: 'lód-nòi-dâi-mǎi',
        note: '更直接的说法：ลดได้ไหม (lód-dâi-mǎi)',
      ),
      LanguagePhrase(
        id: 'buy_this',
        chinese: '我要买这个',
        thai: 'จะเอาอันนี้',
        romanization: 'jà-ao-an-nîi',
        note: '',
      ),
      LanguagePhrase(
        id: 'credit_card',
        chinese: '可以刷卡吗？',
        thai: 'จ่ายบัตรเครดิตได้ไหม',
        romanization: 'jàai-bàt-khrèe-dìt-dâi-mǎi',
        note: '路边摊通常只收现金',
      ),
      LanguagePhrase(
        id: 'cash_only',
        chinese: '只收现金',
        thai: 'รับเฉพาะเงินสด',
        romanization: 'ráp-chá-phá-ngern-sòt',
        note: '',
      ),
      LanguagePhrase(
        id: 'just_looking',
        chinese: '只是看看',
        thai: 'แค่ดูก่อน',
        romanization: 'khaê-duu-kòn',
        note: '避免被小贩一直推销',
      ),
      LanguagePhrase(
        id: 'refund',
        chinese: '可以退货吗？',
        thai: 'คืนของได้ไหม',
        romanization: 'khuuen-khǒrng-dâi-mǎi',
        note: '在商场购物时使用',
      ),
    ],
  ),

  // 5. 交通出行
  LanguageScene(
    id: 'transport',
    name: '交通',
    icon: '🚕',
    description: '出租车、突突车、BTS轻轨、摩托车常用语',
    phrases: [
      LanguagePhrase(
        id: 'call_taxi',
        chinese: '请帮我叫出租车',
        thai: 'ช่วยเรียกรถแท็กซี่หน่อย',
        romanization: 'chûai-rîak-rót-tháek-sîi-nòi',
        note: '',
      ),
      LanguagePhrase(
        id: 'go_to',
        chinese: '去...（地点）',
        thai: 'ไป...',
        romanization: 'bpai...',
        note: '直接告诉司机地点名',
      ),
      LanguagePhrase(
        id: 'use_meter',
        chinese: '请打表',
        thai: 'ใช้มิเตอร์หน่อย',
        romanization: 'chái-mí-dter-nòi',
        note: '上车前一定要说，避免一口价',
      ),
      LanguagePhrase(
        id: 'stop_here',
        chinese: '请在这里停',
        thai: 'จอดตรงนี้',
        romanization: 'jòot-trong-nîi',
        note: '',
      ),
      LanguagePhrase(
        id: 'how_much_to',
        chinese: '到...多少钱？',
        thai: 'ไป...เท่าไหร่',
        romanization: 'bpai...thâo-rài',
        note: '先问价再上车（尤其突突车）',
      ),
      LanguagePhrase(
        id: 'in_a_hurry',
        chinese: '我赶时间',
        thai: 'ฉันรีบ',
        romanization: 'chǎn-rîip',
        note: '可加 หน่อย (nòi) 表示“有点赶”',
      ),
      LanguagePhrase(
        id: 'slow_down',
        chinese: '开慢一点',
        thai: 'ช้าลงหน่อย',
        romanization: 'cháa-long-nòi',
        note: '对摩托车或突突车说',
      ),
      LanguagePhrase(
        id: 'bts_station',
        chinese: 'BTS轻轨站在哪？',
        thai: 'สถานีบีทีเอสอยู่ที่ไหน',
        romanization: 'sà-tǎa-nii-bii-thii-ét yùu-thîi-nǎi',
        note: '曼谷常用轨道交通',
      ),
    ],
  ),

  // 6. 住宿
  LanguageScene(
    id: 'accommodation',
    name: '住宿',
    icon: '🏨',
    description: '酒店、民宿、青旅常用对话',
    phrases: [
      LanguagePhrase(
        id: 'have_reservation',
        chinese: '我有预订',
        thai: 'จองไว้แล้ว',
        romanization: 'joong-wái-léeo',
        note: '加ชื่อ (chûue) 名字：จองไว้ในชื่อ...',
      ),
      LanguagePhrase(
        id: 'any_room',
        chinese: '还有空房吗？',
        thai: 'ยังมีห้องว่างไหม',
        romanization: 'yang-míi-hông-wâang-mǎi',
        note: '',
      ),
      LanguagePhrase(
        id: 'see_room',
        chinese: '可以看房间吗？',
        thai: 'ดูห้องได้ไหม',
        romanization: 'duu-hông-dâi-mǎi',
        note: '先看房再决定',
      ),
      LanguagePhrase(
        id: 'one_night',
        chinese: '住一晚',
        thai: 'พักหนึ่งคืน',
        romanization: 'phák-nèung-khuuen',
        note: '两晚：สองคืน (sǒng-khuuen)',
      ),
      LanguagePhrase(
        id: 'checkout_time',
        chinese: '几点退房？',
        thai: 'กี่โมงเช็คเอาท์',
        romanization: 'kìi-moong-chék-ao',
        note: '',
      ),
      LanguagePhrase(
        id: 'wifi_password',
        chinese: 'WiFi密码是多少？',
        thai: 'รหัสไวไฟอะไร',
        romanization: 'rá-hàt-wai-fai-à-rai',
        note: '',
      ),
      LanguagePhrase(
        id: 'ac_broken',
        chinese: '空调坏了',
        thai: 'แอร์เสีย',
        romanization: 'ae-sǐia',
        note: '请维修：ช่วยซ่อมหน่อย (chûai-sôm-nòi)',
      ),
      LanguagePhrase(
        id: 'safe_deposit',
        chinese: '有保险箱吗？',
        thai: 'มีตู้เซฟไหม',
        romanization: 'míi-tûu-séef-mǎi',
        note: '存放贵重物品',
      ),
    ],
  ),

  // 7. 数字与时间（超实用）
  LanguageScene(
    id: 'numbers_time',
    name: '数字与时间',
    icon: '🔢',
    description: '泰语数字和时间的表达，与价格、时间紧密相关',
    phrases: [
      LanguagePhrase(
        id: 'num_1',
        chinese: '1 到 10',
        thai: '๑-๑๐',
        romanization: 'nèung / sǒng / sǎam / sìi / hâa / hòk / jèt / bpàaet / gâo / sìp',
        note: '泰语数字写法：๑ ๒ ๓ ๔ ๕ ๖ ๗ ๘ ๙ ๑๐',
      ),
      LanguagePhrase(
        id: 'num_11_20',
        chinese: '11 到 20',
        thai: '๑๑-๒๐',
        romanization: 'sìp-èt / sìp-sǒng / sìp-sǎam / sìp-sìi / sìp-hâa / sìp-hòk / sìp-jèt / sìp-bpàaet / sìp-gâo / yîi-sìp',
        note: 'yîi-sìp = 20',
      ),
      LanguagePhrase(
        id: 'num_100',
        chinese: '100 / 1000',
        thai: '๑๐๐ / ๑๐๐๐',
        romanization: 'nèung-rói / nèung-pan',
        note: 'rói=百, pan=千',
      ),
      LanguagePhrase(
        id: 'what_time',
        chinese: '几点了？',
        thai: 'กี่โมงแล้ว',
        romanization: 'kìi-moong-léeo',
        note: '回答：ตี 1 (tii nèung) 凌晨1点, บ่าย 2 (bàai sǒng) 下午2点',
      ),
      LanguagePhrase(
        id: 'how_long',
        chinese: '要多久？',
        thai: 'นานเท่าไหร่',
        romanization: 'naan-thâo-rài',
        note: '问车程或等待时间',
      ),
    ],
  ),

  // 8. 医疗与健康
  LanguageScene(
    id: 'medical',
    name: '医疗',
    icon: '🏥',
    description: '身体不适或需要药物时使用',
    phrases: [
      LanguagePhrase(
        id: 'not_feel_well',
        chinese: '我不舒服',
        thai: 'ไม่สบาย',
        romanization: 'mâi-sà-baai',
        note: '可加 มาก (mâak) 表示非常不舒服',
      ),
      LanguagePhrase(
        id: 'need_doctor',
        chinese: '我需要医生',
        thai: 'ต้องการหมอ',
        romanization: 'tông-gaan-mǒr',
        note: '紧急情况说 ช่วยด้วย ฉันต้องการหมอ (chûai-dûai chǎn tông-gaan mǒr)',
      ),
      LanguagePhrase(
        id: 'hospital',
        chinese: '医院在哪？',
        thai: 'โรงพยาบาลอยู่ที่ไหน',
        romanization: 'roong-pá-yaa-baan yùu-thîi-nǎi',
        note: '',
      ),
      LanguagePhrase(
        id: 'pharmacy',
        chinese: '药店',
        thai: 'ร้านขายยา',
        romanization: 'ráan-khǎai-yaa',
        note: '通常有药剂师',
      ),
      LanguagePhrase(
        id: 'symptom',
        chinese: '头痛 / 胃痛 / 发烧',
        thai: 'ปวดหัว / ปวดท้อง / เป็นไข้',
        romanization: 'pùuat-hǔa / pùuat-thóng / bpen-khâi',
        note: '泰国7-11也卖常用药',
      ),
      LanguagePhrase(
        id: 'allergy',
        chinese: '我对...过敏',
        thai: 'แพ้...',
        romanization: 'pháe...',
        note: '例：แพ้ถั่ว (pháe-thùa) 花生过敏',
      ),
    ],
  ),

  // 9. 货币与兑换
  LanguageScene(
    id: 'currency',
    name: '货币兑换',
    icon: '💰',
    description: '换汇、ATM取款相关用语',
    phrases: [
      LanguagePhrase(
        id: 'exchange_rate',
        chinese: '汇率是多少？',
        thai: 'อัตราแลกเปลี่ยนเท่าไหร่',
        romanization: 'àt-traa-lâek-bplìan-thâo-rài',
        note: '',
      ),
      LanguagePhrase(
        id: 'exchange_money',
        chinese: '我要换钱',
        thai: 'ขอแลกเงิน',
        romanization: 'khǒr-lâek-ngern',
        note: '通常在 SuperRich 或银行兑换',
      ),
      LanguagePhrase(
        id: 'atm',
        chinese: 'ATM机在哪里？',
        thai: 'ตู้เอทีเอ็มอยู่ที่ไหน',
        romanization: 'tûu-ee-thii-em yùu-thîi-nǎi',
        note: '泰国ATM每次取款收手续费',
      ),
      LanguagePhrase(
        id: 'change_bills',
        chinese: '可以换零钱吗？',
        thai: 'ขอแลกแบงค์ย่อยได้ไหม',
        romanization: 'khǒr-lâek-baeng-yôi-dâi-mǎi',
        note: '7-11或便利店通常愿意帮忙',
      ),
    ],
  ),

  // 10. 拍照与游览
  LanguageScene(
    id: 'sightseeing',
    name: '拍照游览',
    icon: '📸',
    description: '请人帮忙拍照、询问景点',
    phrases: [
      LanguagePhrase(
        id: 'take_photo',
        chinese: '请帮我拍照',
        thai: 'ช่วยถ่ายรูปให้หน่อย',
        romanization: 'chûai-thàai-rûup-hâi-nòi',
        note: '通常泰国人都很乐意帮忙',
      ),
      LanguagePhrase(
        id: 'where_temple',
        chinese: '最近的寺庙在哪？',
        thai: 'วัดที่ใกล้ที่สุดอยู่ที่ไหน',
        romanization: 'wát-thîi-klâi-thîi-sòot yùu-thîi-nǎi',
        note: '泰国寺庙众多',
      ),
      LanguagePhrase(
        id: 'entrance_fee',
        chinese: '门票多少钱？',
        thai: 'ค่าเข้าชมเท่าไหร่',
        romanization: 'khâa-khâo-chom-thâo-rài',
        note: '',
      ),
      LanguagePhrase(
        id: 'open_hours',
        chinese: '几点开门/关门？',
        thai: 'เปิด/ปิด กี่โมง',
        romanization: 'bpèrt / bpìt kìi-moong',
        note: '',
      ),
    ],
  ),

  // 11. 紧急求助（核心安全）
  LanguageScene(
    id: 'emergency',
    name: '紧急求助',
    icon: '🆘',
    description: '遇到危险或突发状况时使用',
    phrases: [
      LanguagePhrase(
        id: 'help',
        chinese: '救命！',
        thai: 'ช่วยด้วย!',
        romanization: 'chûai-dûai!',
        note: '大声喊叫，同时跑到人多的地方',
      ),
      LanguagePhrase(
        id: 'lost',
        chinese: '我迷路了',
        thai: 'หลงทาง',
        romanization: 'lǒng-thaang',
        note: '加 ฉัน (chǎn) 我',
      ),
      LanguagePhrase(
        id: 'call_police',
        chinese: '请帮我叫警察',
        thai: 'ช่วยเรียกตำรวจ',
        romanization: 'chûai-rîak-tam-rùat',
        note: '泰国报警电话 191',
      ),
      LanguagePhrase(
        id: 'stolen',
        chinese: '我的包被偷了',
        thai: 'กระเป๋าถูกขโมย',
        romanization: 'grà-bpǎo-thùuk-khà-mooi',
        note: '替换物品：โทรศัพท์ (thoo-rá-sàp) 手机, กระเป๋าสตางค์ (grà-bpǎo-sà-dtaang) 钱包',
      ),
      LanguagePhrase(
        id: 'chinese_speaker',
        chinese: '有人会说中文吗？',
        thai: 'มีใครพูดจีนได้ไหม',
        romanization: 'mii-krai-pûut-jiin-dâi-mǎi',
        note: '泰国旅游区很多商家会说简单中文',
      ),
      LanguagePhrase(
        id: 'call_embassy',
        chinese: '请帮我联系中国大使馆',
        thai: 'ช่วยติดต่อสถานทูตจีนให้หน่อย',
        romanization: 'chûai-dtìt-dtòr-sà-tǎan-thûut-jiin-hâi-nòi',
        note: '中国驻泰使馆电话 +66-2-2450088',
      ),
    ],
  ),

  // 12. 常用应答与礼貌用语
  LanguageScene(
    id: 'responses',
    name: '常用应答',
    icon: '💬',
    description: '日常对话中简短有力的回应',
    phrases: [
      LanguagePhrase(
        id: 'yes',
        chinese: '是 / 对的',
        thai: 'ใช่',
        romanization: 'châi',
        note: '注意不是“chai”的英语发音，声调是降调',
      ),
      LanguagePhrase(
        id: 'no',
        chinese: '不是',
        thai: 'ไม่ใช่',
        romanization: 'mâi-châi',
        note: '',
      ),
      LanguagePhrase(
        id: 'have',
        chinese: '有',
        thai: 'มี',
        romanization: 'mii',
        note: '例：มีน้ำ (mii-náam) 有水',
      ),
      LanguagePhrase(
        id: 'dont_have',
        chinese: '没有',
        thai: 'ไม่มี',
        romanization: 'mâi-mii',
        note: '',
      ),
      LanguagePhrase(
        id: 'can',
        chinese: '可以',
        thai: 'ได้',
        romanization: 'dâi',
        note: '万能词：ได้ครับ/ค่ะ',
      ),
      LanguagePhrase(
        id: 'cannot',
        chinese: '不可以',
        thai: 'ไม่ได้',
        romanization: 'mâi-dâi',
        note: '',
      ),
      LanguagePhrase(
        id: 'understand',
        chinese: '明白',
        thai: 'เข้าใจ',
        romanization: 'khâo-jai',
        note: '不明白：ไม่เข้าใจ (mâi-khâo-jai)',
      ),
      LanguagePhrase(
        id: 'sorry_no',
        chinese: '不好意思，不用了',
        thai: 'ไม่เป็นไร ขอบคุณ',
        romanization: 'mâi-pen-rai khòp-khun',
        note: '礼貌拒绝推销',
      ),
    ],
  ),

  // 13. 特色场景：寺庙礼仪
  LanguageScene(
    id: 'temple',
    name: '寺庙礼仪',
    icon: '🛕',
    description: '泰国佛教寺庙参观时的注意事项和用语',
    phrases: [
      LanguagePhrase(
        id: 'dress_code',
        chinese: '请穿着得体（遮肩盖膝）',
        thai: 'กรุณาแต่งกายให้สุภาพเรียบร้อย',
        romanization: 'gà-rú-naa-dtàeng-gaai-hâi-sù-pâap-rîap-rói',
        note: '很多寺庙门口有免费借用的围裙',
      ),
      LanguagePhrase(
        id: 'remove_shoes',
        chinese: '请脱鞋',
        thai: 'กรุณาถอดรองเท้า',
        romanization: 'gà-rú-naa-thòd-roong-tháo',
        note: '进入大殿必须脱鞋',
      ),
      LanguagePhrase(
        id: 'no_touching',
        chinese: '请不要触摸佛像',
        thai: 'กรุณาอย่าสัมผัสพระพุทธรูป',
        romanization: 'yàa-sám-pàt-phrá-phút-thá-rûup',
        note: '对佛像不敬是严重错误',
      ),
      LanguagePhrase(
        id: 'wai',
        chinese: '合十礼 (Wai)',
        thai: 'ไหว้',
        romanization: 'wâi',
        note: '双手合十，指尖越贴近鼻尖表示越尊敬，对僧侣需高过头',
      ),
    ],
  ),
];