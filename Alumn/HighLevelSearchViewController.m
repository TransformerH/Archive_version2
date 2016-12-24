//
//  ViewController.m
//  TextFieldAndPickerView
//
//  Created by 韩雪滢 on 12/22/16.
//  Copyright © 2016 韩雪滢. All rights reserved.
//

#import "HighLevelSearchViewController.h"
#import "FacultyTextField.h"
#import "YearTextField.h"
#import "placeTextField.h"

#import "User.h"
#import "User+Extension.h"
#import "PeopleViewModel.h"
#import "PeopleViewController.h"
#import "TextFieldSender.h"


@interface HighLevelSearchViewController ()

@property (weak, nonatomic) IBOutlet FacultyTextField *facultyTextField;
@property (strong,nonatomic) UITableView *facultyTable;

@property (weak, nonatomic) IBOutlet YearTextField *yearTextField;

@property (weak, nonatomic) IBOutlet placeTextField *cscTextField;
@property (strong,nonatomic) UITableView *placeTable;

@property (strong,nonatomic) NSMutableArray *facultyArray;
@property (strong,nonatomic) NSMutableArray *cscArray;

@property (strong,nonatomic) NSMutableArray *facultyOnlyArray;
@property (strong,nonatomic) NSMutableArray *majorOnlyArray;

@property (strong,nonatomic) TextFieldSender *sender;

@end

@implementation HighLevelSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.facultyTable = (id)[self.view viewWithTag:1];
    self.placeTable = (id)[self.view viewWithTag:2];
    self.facultyArray = [[NSMutableArray alloc] init];
    self.cscArray = [[NSMutableArray alloc] init];
    self.facultyOnlyArray = [[NSMutableArray alloc] init];
    self.majorOnlyArray = [[NSMutableArray alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"majorList" ofType:@"plist"];
    self.facultyTextField.facultiesAndMajors = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    for(int i = 1905;i < 2017;i++){
        [tempArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    self.yearTextField.yearArray = [[NSArray alloc] initWithArray:tempArray];
    
    self.cscTextField.countrySource = @[@"中国", @"阿尔巴尼亚", @"阿尔及利亚", @"阿富汗", @"阿根廷", @"阿拉伯联合酋长国", @"阿鲁巴", @"阿曼", @"阿塞拜疆", @"阿森松岛", @"埃及", @"埃塞俄比亚", @"爱尔兰", @"爱沙尼亚", @"安道尔", @"安哥拉", @"安圭拉", @"安提瓜岛和巴布达", @"澳大利亚", @"奥地利", @"奥兰群岛", @"巴巴多斯岛", @"巴布亚新几内亚", @"巴哈马", @"巴基斯坦", @"巴拉圭", @"巴勒斯坦", @"巴林", @"巴拿马", @"巴西", @"白俄罗斯", @"百慕大", @"保加利亚", @"北马里亚纳群岛", @"贝宁", @"比利时", @"冰岛", @"波多黎各", @"波兰", @"玻利维亚", @"波斯尼亚和黑塞哥维那", @"博茨瓦纳", @"伯利兹", @"不丹", @"布基纳法索", @"布隆迪", @"布韦岛", @"朝鲜", @"丹麦", @"德国", @"东帝汶", @"多哥", @"多米尼加", @"多米尼加共和国", @"俄罗斯", @"厄瓜多尔", @"厄立特里亚", @"法国", @"法罗群岛", @"法属波利尼西亚", @"法属圭亚那", @"法属南部领地", @"梵蒂冈", @"菲律宾", @"斐济", @"芬兰", @"佛得角", @"弗兰克群岛", @"冈比亚", @"刚果", @"刚果民主共和国", @"哥伦比亚", @"哥斯达黎加", @"格恩西岛", @"格林纳达", @"格陵兰", @"古巴", @"瓜德罗普", @"关岛", @"圭亚那", @"哈萨克斯坦", @"海地", @"韩国", @"荷兰", @"荷属安地列斯", @"赫德和麦克唐纳群岛", @"洪都拉斯", @"基里巴斯", @"吉布提", @"吉尔吉斯斯坦", @"几内亚", @"几内亚比绍", @"加拿大", @"加纳", @"加蓬", @"柬埔寨", @"捷克共和国", @"津巴布韦", @"喀麦隆", @"卡塔尔", @"开曼群岛", @"科科斯群岛", @"科摩罗", @"科特迪瓦", @"科威特", @"克罗地亚", @"肯尼亚", @"库克群岛", @"拉脱维亚", @"莱索托", @"老挝", @"黎巴嫩", @"利比里亚", @"利比亚", @"立陶宛", @"列支敦士登", @"留尼旺岛", @"卢森堡", @"卢旺达", @"罗马尼亚", @"马达加斯加", @"马尔代夫", @"马耳他", @"马拉维", @"马来西亚", @"马里", @"马其顿", @"马绍尔群岛", @"马提尼克", @"马约特岛", @"曼岛", @"毛里求斯", @"毛里塔尼亚", @"美国", @"美属萨摩亚", @"美属外岛", @"蒙古", @"蒙特塞拉特", @"孟加拉", @"密克罗尼西亚", @"秘鲁", @"缅甸", @"摩尔多瓦", @"摩洛哥", @"摩纳哥", @"莫桑比克", @"墨西哥", @"纳米比亚", @"南非", @"南极洲", @"南乔治亚和南桑德威奇群岛", @"瑙鲁", @"尼泊尔", @"尼加拉瓜", @"尼日尔", @"尼日利亚", @"纽埃", @"挪威", @"诺福克", @"帕劳群岛", @"皮特凯恩", @"葡萄牙", @"乔治亚", @"日本", @"瑞典", @"瑞士", @"萨尔瓦多", @"萨摩亚", @"塞尔维亚,黑山", @"塞拉利昂", @"塞内加尔", @"塞浦路斯", @"塞舌尔", @"沙特阿拉伯", @"圣诞岛", @"圣多美和普林西比", @"圣赫勒拿", @"圣基茨和尼维斯", @"圣卢西亚", @"圣马力诺", @"圣皮埃尔和米克隆群岛", @"圣文森特和格林纳丁斯", @"斯里兰卡", @"斯洛伐克", @"斯洛文尼亚", @"斯瓦尔巴和扬马廷", @"斯威士兰", @"苏丹", @"苏里南", @"所罗门群岛", @"索马里", @"塔吉克斯坦", @"泰国", @"坦桑尼亚", @"汤加", @"特克斯和凯克特斯群岛", @"特里斯坦达昆哈", @"特立尼达和多巴哥", @"突尼斯", @"图瓦卢", @"土耳其", @"土库曼斯坦", @"托克劳", @"瓦利斯和福图纳", @"瓦努阿图", @"危地马拉", @"维尔京群岛，美属", @"维尔京群岛，英属", @"委内瑞拉", @"文莱", @"乌干达", @"乌克兰", @"乌拉圭", @"乌兹别克斯坦", @"西班牙", @"希腊", @"新加坡", @"新喀里多尼亚", @"新西兰", @"匈牙利", @"叙利亚", @"牙买加", @"亚美尼亚", @"也门", @"伊拉克", @"伊朗", @"以色列", @"意大利", @"印度", @"印度尼西亚", @"英国", @"英属印度洋领地", @"约旦", @"越南", @"赞比亚", @"泽西岛", @"乍得", @"直布罗陀", @"智利", @"中非共和国"];
    
    self.cscTextField.stateSource = @[@[@"北京", @"天津", @"河北", @"山西", @"内蒙古", @"辽宁", @"吉林", @"黑龙江", @"上海", @"江苏", @"浙江", @"安徽", @"福建", @"江西", @"山东", @"河南", @"湖北", @"湖南", @"广东", @"广西", @"海南", @"重庆", @"四川", @"贵州", @"云南", @"西藏", @"陕西", @"甘肃", @"青海", @"宁夏", @"新疆", @"台湾", @"香港", @"澳门"], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[@"北部地区", @"堪培拉", @"昆士兰", @"南澳大利亚", @"塔斯马尼亚", @"维多利亚", @"西澳大利亚", @"新南威尔士"], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[@"大邱", @"大田", @"釜山", @"光州", @"济州特别自治道", @"江原道", @"京畿道", @"庆尚北道", @"庆尚南道", @"全罗北道", @"全罗南道", @"仁川", @"首尔", @"蔚山", @"忠清北道", @"忠清南道"], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[@"槟榔屿", @"玻璃市", @"丁加奴", @"吉打", @"吉兰丹", @"吉隆坡", @"马六甲", @"纳闽", @"彭亨", @"霹雳", @"柔佛", @"森美兰", @"沙巴", @"沙捞越", @"雪兰莪"], @[], @[], @[], @[], @[], @[], @[], @[], @[@"阿肯色", @"阿拉巴马", @"阿拉斯加", @"爱达荷", @"爱荷华", @"北达科他", @"北卡罗来纳", @"宾夕法尼亚", @"德克萨斯", @"俄亥俄", @"俄克拉荷马", @"俄勒冈", @"佛罗里达", @"佛蒙特", @"哥伦比亚特区", @"华盛顿", @"怀俄明", @"加利福尼亚", @"堪萨斯", @"康涅狄格", @"科罗拉多", @"肯塔基", @"路易斯安那", @"罗德岛", @"马里兰", @"马萨诸塞", @"蒙大拿", @"密苏里", @"密西西比", @"密歇根", @"缅因", @"明尼苏达", @"南达科他", @"南卡罗来纳", @"内布拉斯加", @"内华达", @"纽约", @"特拉华", @"田纳西", @"威斯康星", @"维吉尼亚", @"西佛吉尼亚", @"夏威夷", @"新罕布什尔", @"新墨西哥", @"新泽西", @"亚利桑那", @"伊利诺斯", @"印第安那", @"犹他", @"佐治亚"], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[], @[@"北爱尔兰", @"苏格兰", @"威尔士", @"英格兰"], @[], @[], @[], @[], @[], @[], @[], @[], @[]];
    
    self.cscTextField.citySource = @[@[@"东城", @"西城", @"朝阳", @"丰台", @"石景山", @"海淀", @"门头沟", @"房山", @"通州", @"顺义", @"昌平", @"大兴", @"平谷", @"怀柔", @"密云", @"延庆"], @[@"和平", @"河东", @"河西", @"南开", @"河北", @"红桥", @"滨海新区", @"东丽", @"西青", @"津南", @"北辰", @"宁河", @"武清", @"静海", @"宝坻", @"蓟县"], @[@"石家庄", @"唐山", @"秦皇岛", @"邯郸", @"邢台", @"保定", @"张家口", @"承德", @"沧州", @"廊坊", @"衡水"], @[@"太原", @"大同", @"阳泉", @"长治", @"晋城", @"朔州", @"晋中", @"运城", @"忻州", @"临汾", @"吕梁"], @[@"呼和浩特", @"包头", @"乌海", @"赤峰", @"通辽", @"鄂尔多斯", @"呼伦贝尔", @"巴彦淖尔", @"乌兰察布", @"兴安", @"锡林郭勒", @"阿拉善"], @[@"沈阳", @"大连", @"鞍山", @"抚顺", @"本溪", @"丹东", @"锦州", @"营口", @"阜新", @"辽阳", @"盘锦", @"铁岭", @"朝阳", @"葫芦岛"], @[@"长春", @"吉林", @"四平", @"辽源", @"通化", @"白山", @"松原", @"白城", @"延边"], @[@"哈尔滨", @"齐齐哈尔", @"鸡西", @"鹤岗", @"双鸭山", @"大庆", @"伊春", @"佳木斯", @"七台河", @"牡丹江", @"黑河", @"绥化", @"大兴安岭"], @[@"黄浦", @"卢湾", @"徐汇", @"长宁", @"静安", @"普陀", @"闸北", @"虹口", @"杨浦", @"闵行", @"宝山", @"嘉定", @"浦东新区", @"金山", @"松江", @"奉贤", @"青浦", @"崇明"], @[@"南京", @"无锡", @"徐州", @"常州", @"苏州", @"南通", @"连云港", @"淮安", @"盐城", @"扬州", @"镇江", @"泰州", @"宿迁"], @[@"杭州", @"宁波", @"温州", @"嘉兴", @"湖州", @"绍兴", @"金华", @"衢州", @"舟山", @"台州", @"丽水"], @[@"合肥", @"芜湖", @"蚌埠", @"淮南", @"马鞍山", @"淮北", @"铜陵", @"安庆", @"黄山", @"滁州", @"阜阳", @"宿州", @"六安", @"亳州", @"池州", @"宣城"], @[@"福州", @"厦门", @"莆田", @"三明", @"泉州", @"漳州", @"南平", @"龙岩", @"宁德"], @[@"南昌", @"景德镇", @"萍乡", @"九江", @"新余", @"鹰潭", @"赣州", @"吉安", @"宜春", @"抚州", @"上饶"], @[@"济南", @"青岛", @"淄博", @"枣庄", @"东营", @"烟台", @"潍坊", @"济宁", @"泰安", @"威海", @"日照", @"莱芜", @"临沂", @"德州", @"聊城", @"滨州", @"菏泽"], @[@"郑州", @"开封", @"洛阳", @"平顶山", @"安阳", @"鹤壁", @"新乡", @"焦作", @"濮阳", @"许昌", @"漯河", @"三门峡", @"南阳", @"商丘", @"信阳", @"周口", @"驻马店", @"济源"], @[@"武汉", @"黄石", @"十堰", @"宜昌", @"襄阳", @"鄂州", @"荆门", @"孝感", @"荆州", @"黄冈", @"咸宁", @"随州", @"恩施", @"仙桃", @"潜江", @"天门", @"神农架"], @[@"长沙", @"株洲", @"湘潭", @"衡阳", @"邵阳", @"岳阳", @"常德", @"张家界", @"益阳", @"郴州", @"永州", @"怀化", @"娄底", @"湘西"], @[@"广州", @"韶关", @"深圳", @"珠海", @"汕头", @"佛山", @"江门", @"湛江", @"茂名", @"肇庆", @"惠州", @"梅州", @"汕尾", @"河源", @"阳江", @"清远", @"东莞", @"中山", @"潮州", @"揭阳", @"云浮"], @[@"南宁", @"柳州", @"桂林", @"梧州", @"北海", @"防城港", @"钦州", @"贵港", @"玉林", @"百色", @"贺州", @"河池", @"来宾", @"崇左"], @[@"海口", @"三亚", @"三沙", @"五指山", @"琼海", @"儋州", @"文昌", @"万宁", @"东方", @"定安", @"屯昌", @"澄迈", @"临高", @"白沙", @"昌江", @"乐东", @"陵水", @"保亭", @"琼中"], @[@"万州", @"涪陵", @"渝中", @"大渡口", @"江北", @"沙坪坝", @"九龙坡", @"南岸", @"北碚", @"两江新区", @"万盛", @"双桥", @"渝北", @"巴南", @"长寿", @"綦江", @"潼南", @"铜梁", @"大足", @"荣昌", @"璧山", @"梁平", @"城口", @"丰都", @"垫江", @"武隆", @"忠县", @"开县", @"云阳", @"奉节", @"巫山", @"巫溪", @"黔江", @"石柱", @"秀山", @"酉阳", @"彭水", @"江津", @"合川", @"永川", @"南川"], @[@"成都", @"自贡", @"攀枝花", @"泸州", @"德阳", @"绵阳", @"广元", @"遂宁", @"内江", @"乐山", @"南充", @"眉山", @"宜宾", @"广安", @"达州", @"雅安", @"巴中", @"资阳", @"阿坝", @"甘孜", @"凉山"], @[@"贵阳", @"六盘水", @"遵义", @"安顺", @"铜仁", @"黔西南", @"毕节", @"黔东南", @"黔南"], @[@"昆明", @"曲靖", @"玉溪", @"保山", @"昭通", @"丽江", @"普洱", @"临沧", @"楚雄", @"红河", @"文山", @"西双版纳", @"大理", @"德宏", @"怒江", @"迪庆"], @[@"拉萨", @"昌都", @"山南", @"日喀则", @"那曲", @"阿里", @"林芝"], @[@"西安", @"铜川", @"宝鸡", @"咸阳", @"渭南", @"延安", @"汉中", @"榆林", @"安康", @"商洛"], @[@"兰州市", @"嘉峪关", @"金昌", @"白银", @"天水", @"武威", @"张掖", @"平凉", @"酒泉", @"庆阳", @"定西", @"陇南", @"临夏", @"甘南"], @[@"西宁", @"海东", @"海北", @"黄南", @"海南", @"果洛", @"玉树", @"海西"], @[@"银川", @"石嘴山", @"吴忠", @"固原", @"中卫"], @[@"乌鲁木齐", @"克拉玛依", @"吐鲁番", @"哈密", @"昌吉", @"博尔塔拉", @"巴音郭楞", @"阿克苏", @"克孜勒苏", @"喀什", @"和田", @"伊犁", @"塔城", @"阿勒泰", @"石河子", @"阿拉尔", @"图木舒克", @"五家渠", @"北屯"], @[@"台北市", @"高雄市", @"基隆市", @"台中市", @"台南市", @"新竹市", @"嘉义市", @"台北县", @"宜兰县", @"桃园县", @"新竹县", @"苗栗县", @"台中县", @"彰化县", @"南投县", @"云林县", @"嘉义县", @"台南县", @"高雄县", @"屏东县", @"台东县", @"花莲县", @"澎湖县"], @[@"中西区", @"东区", @"九龙城区", @"观塘区", @"南区", @"深水埗区", @"黄大仙区", @"湾仔区", @"油尖旺区", @"离岛区", @"葵青区", @"北区", @"西贡区", @"沙田区", @"屯门区", @"大埔区", @"荃湾区", @"元朗区"], @[@"花地玛堂区", @"圣安多尼堂区", @"大堂区", @"望德堂区", @"风顺堂区", @"氹仔", @"路环"], @[@"北帕默斯顿", @"达尔文"], @[@"堪培拉"], @[@"布里斯班", @"黄金海岸", @"凯恩斯", @"日光海岸", @"汤斯维尔", @"图文巴"], @[@"阿德莱德", @"奥古斯塔港", @"甘比亚山", @"怀阿拉", @"林肯港", @"默里布里奇", @"皮里港", @"维克托港"], @[@"伯尼港", @"德文波特", @"霍巴特", @"朗塞斯顿"], @[@"吉朗", @"墨尔本"], @[@"奥尔巴尼", @"班伯里", @"弗里曼特尔港", @"杰拉尔顿", @"卡尔古利", @"曼哲拉", @"珀斯"], @[@"纽卡斯尔", @"伍伦贡", @"悉尼"], @[@"达城郡", @"大邱", @"寿城区"], @[], @[], @[], @[], @[@"春川市", @"东海市", @"高城郡", @"横城郡", @"洪川郡", @"华川郡", @"江陵市", @"旌善郡", @"麟蹄郡", @"宁越郡", @"平昌郡", @"三陟市", @"束草市", @"太白市", @"铁原郡", @"襄阳郡", @"杨口郡", @"原州市"], @[@"安城市", @"安山市", @"安养市", @"抱川市", @"城南市", @"东豆川市", @"富川市", @"高阳市", @"光明市", @"广州市", @"果川市", @"河南市", @"华城市", @"加平郡", @"金浦市", @"九里市", @"军浦市", @"骊州郡", @"利川市", @"涟川郡", @"龙仁市", @"南杨州市", @"平泽市", @"坡州市", @"始兴市", @"水原市", @"乌山市", @"扬平郡", @"杨州市", @"仪旺市", @"议政府市"], @[@"安东市", @"奉化郡", @"高灵郡", @"龟尾市", @"金泉市", @"军威郡", @"醴泉郡", @"浦项市", @"漆谷郡", @"淸道郡", @"靑松郡", @"庆山市", @"庆州市", @"荣州市", @"尙州市", @"蔚珍郡", @"闻庆市", @"星州郡", @"义城郡", @"英阳郡", @"盈德郡", @"永川市", @"郁陵郡"], @[@"昌宁郡", @"昌原市", @"固城郡", @"河东郡", @"金海市", @"晋州市", @"居昌郡", @"巨济市", @"梁山市", @"马山市", @"密阳市", @"南海郡", @"山淸郡", @"泗川市", @"统营市", @"陜川郡", @"咸安郡", @"咸阳郡", @"宜宁郡", @"鎭海市"], @[@"淳昌郡", @"扶安郡", @"高敞郡", @"金堤市", @"井邑市", @"茂朱郡", @"南原市", @"全州市", @"群山市", @"任实郡", @"完州郡", @"益山市", @"长水郡", @"鎭安郡"], @[@"宝城郡", @"高兴郡", @"谷城郡", @"莞岛郡", @"光阳市", @"海南郡", @"和顺郡", @"康津郡", @"丽水市", @"灵光郡", @"灵岩郡", @"罗州市", @"木浦市", @"求礼郡", @"顺天市", @"潭阳郡", @"务安郡", @"咸平郡", @"新安郡", @"长城郡", @"长兴郡", @"珍岛郡"], @[], @[], @[], @[@"报恩郡", @"曾坪郡", @"丹阳郡", @"堤川市", @"槐山郡", @"淸原郡", @"淸州市", @"沃川郡", @"阴城郡", @"永同郡", @"鎭川郡", @"忠州市"], @[@"保宁市", @"扶余郡", @"公州市", @"洪城郡", @"鸡龙市", @"锦山郡", @"礼山郡", @"论山市", @"青阳郡", @"瑞山市", @"舒川郡", @"泰安郡", @"唐津郡", @"天安市", @"牙山市", @"燕岐郡"], @[@"北海", @"槟城", @"大山脚", @"高渊"], @[@"加央"], @[@"甘马挽", @"瓜拉丁加奴", @"龙运", @"马江", @"实兆", @"乌鲁", @"勿述"], @[@"巴东得腊", @"笨筒", @"浮罗交怡", @"哥打士打", @"古邦巴素", @"瓜拉姆达", @"华玲", @"居林", @"万拉峇鲁"], @[@"巴西富地", @"巴西马", @"丹那美拉", @"道北", @"登卓", @"哥打巴鲁", @"瓜拉吉赖", @"话望生", @"马樟", @"日里"], @[@"吉隆坡"], @[@"马六甲市", @"亚罗牙也", @"野新"], @[@"纳闽", @"维多利亚"], @[@"百乐", @"北根", @"淡马鲁", @"而连突", @"关丹", @"金马仑高原", @"劳勿", @"立卑", @"马兰", @"文冬", @"云冰"], @[@"安顺", @"丹绒马", @"和丰", @"紅土坎", @"华都牙也", @"江沙", @"太平", @"怡保"], @[@"笨珍", @"丰盛港", @"哥打丁宜", @"居銮", @"峇株巴辖", @"麻坡", @"昔加末", @"新山"], @[@"波德申", @"淡边", @"芙蓉", @"瓜拉庇劳", @"林茂", @"仁保", @"日叻务"], @[@"吧巴", @"保佛", @"比鲁兰", @"必达士", @"兵南邦", @"担布南", @"丹南", @"斗湖", @"斗亚兰", @"哥打基纳巴鲁", @"哥打马鲁都", @"根地咬", @"古达", @"古打毛律", @"古纳", @"瓜拉班尤", @"京那巴登岸", @"兰脑", @"拿笃", @"纳巴湾", @"山打根", @"西比陶", @"仙本那"], @[@"古晋", @"加帛", @"林梦", @"美里", @"民都鲁", @"木胶", @"木中", @"三马拉汉", @"斯里阿曼", @"泗里街", @"泗务"], @[@"八打灵", @"鹅麦", @"瓜拉冷岳", @"瓜拉雪兰莪", @"沙白安南", @"乌鲁冷岳", @"乌鲁雪兰莪", @"雪邦"], @[@"费耶特维尔", @"史密斯堡", @"小石城"], @[@"伯明罕", @"蒙哥马利", @"莫比尔"], @[@"安克雷奇", @"费尔班克斯", @"朱诺"], @[@"爱达荷福尔斯", @"波卡特洛", @"博伊西", @"布莱克富特", @"科达伦", @"刘易斯顿", @"莫斯科", @"墨菲", @"楠帕", @"岂彻姆", @"森瓦利", @"亚美利加瀑布城"], @[@"达文波特", @"得梅因", @"锡达拉皮兹"], @[@"俾斯麦", @"大福克斯", @"法戈", @"迈诺特"], @[@"艾许维尔", @"杜罕", @"格林斯伯勒", @"教堂山", @"罗利", @"洛利杜罕都会区", @"夏洛特"], @[@"阿伦敦", @"费城", @"匹兹堡"], @[@"埃尔帕索", @"奥斯汀", @"达拉斯", @"哥帕斯基斯蒂", @"交维斯顿", @"拉雷多", @"麦亚伦", @"圣安东尼奥", @"休斯敦"], @[@"代顿", @"哥伦布", @"克利夫兰", @"托莱多", @"辛辛那提"], @[@"俄克拉荷马城", @"诺曼", @"塔尔萨"], @[@"本德", @"波特兰", @"达尔斯", @"达拉斯", @"蒂拉穆克", @"格兰茨帕斯", @"胡德里弗", @"火山口湖", @"科瓦利斯", @"库斯贝", @"梅德福", @"塞勒姆", @"圣海伦斯", @"斯普林菲尔德", @"尤金"], @[@"奥兰多", @"基韦斯特", @"杰克逊维尔", @"卡纳维尔角", @"罗德岱堡", @"迈阿密", @"圣彼德斯堡市", @"塔拉哈西", @"坦帕"], @[@"伯灵顿", @"拉特兰", @"南伯灵顿"], @[@"华盛顿哥伦比亚特区"], @[@"斯波坎", @"塔科马", @"西雅图"], @[@"埃文斯顿", @"卡斯珀", @"拉勒米", @"罗克斯普林斯", @"夏延", @"谢里登"], @[@"旧金山", @"洛杉矶", @"圣迭戈", @"圣何塞"], @[@"阿比林", @"奥弗兰公园", @"哈钦森", @"堪萨斯城", @"莱文沃思", @"劳伦斯", @"曼哈顿", @"托皮卡", @"威奇托"], @[@"布里奇波特", @"达里恩", @"格林尼治", @"哈特福德", @"米德尔顿", @"纽黑文", @"韦斯特波特", @"沃特伯里", @"新不列颠"], @[@"阿斯彭", @"奥罗拉", @"博尔德", @"大章克申", @"丹佛", @"柯林斯堡", @"科罗拉多斯普林斯", @"韦尔"], @[@"列克星敦", @"路易斯维尔", @"欧文斯伯勒"], @[@"巴吞鲁日", @"什里夫波特", @"新奥尔良"], @[@"波塔基特", @"克兰斯顿", @"纽波特", @"普罗维登斯", @"韦斯特利", @"文索基特", @"沃威克"], @[@"巴尔的摩", @"盖瑟斯堡", @"罗克维尔"], @[@"波士顿", @"斯普林菲尔德", @"伍斯特"], @[@"比灵斯", @"大瀑布村", @"米苏拉"], @[@"哥伦比亚", @"杰佛逊市", @"堪萨斯城", @"圣路易斯", @"斯普林菲尔德"], @[@"比洛克西", @"格尔夫波特", @"格林维尔", @"哈蒂斯堡", @"杰克逊", @"默里迪恩", @"维克斯堡"], @[@"安娜堡", @"巴特尔克里克", @"贝城", @"大急流城", @"迪尔伯恩", @"底特律", @"弗林特", @"怀恩多特", @"卡拉马袓", @"兰辛", @"马斯基根", @"庞菷亚克", @"萨吉诺", @"苏圣玛丽", @"沃伦", @"休伦港"], @[@"班戈", @"波特兰", @"刘易斯顿"], @[@"罗切斯特", @"明尼阿波利斯", @"圣保罗"], @[@"阿伯丁", @"拉皮德城", @"苏福尔斯"], @[@"北查尔斯顿", @"查尔斯顿", @"哥伦比亚"], @[@"奥马哈", @"贝尔维尤", @"林肯"], @[@"埃尔科", @"北拉斯维加斯", @"弗吉尼亚城", @"亨德森", @"卡森城", @"拉斯维加斯", @"里诺", @"斯帕克斯"], @[@"布法罗", @"罗切斯特", @"纽约市"], @[@"多佛", @"纽瓦克", @"威明顿"], @[@"布利斯托", @"查塔努加", @"金斯波特", @"孟菲斯", @"纳什维尔", @"诺克斯维尔", @"三城区", @"士麦那", @"斯普林希尔", @"约翰逊城"], @[@"阿普尓顿", @"奥什科什", @"格林贝", @"基诺沙", @"拉克罗斯", @"拉辛", @"马尼托沃克", @"迈迪逊", @"密尔沃基", @"欧克莱尓", @"沃索", @"希博伊根"], @[@"弗吉尼亚比奇", @"诺福克", @"切萨皮克"], @[@"查尔斯顿", @"亨廷顿", @"帕克斯堡"], @[@"凯卢阿", @"檀香山", @"希洛"], @[@"康科德", @"曼彻斯特", @"纳舒厄"], @[@"阿尔伯克基", @"拉斯克鲁塞斯", @"罗斯韦尔", @"圣菲"], @[@"纽瓦克", @"帕特森", @"泽西城"], @[@"凤凰城", @"格兰代尔", @"梅萨", @"史卡兹代尔", @"坦普", @"图森", @"优玛"], @[@"奥尔顿", @"奥罗拉", @"布卢明顿", @"丹维尓", @"迪卡尔布", @"迪凯持", @"东圣路易斯", @"厄巴纳-香槟", @"盖尔斯堡", @"卡本代尔", @"罗克艾兰", @"罗克福德", @"诺黙尔", @"皮奥里亚", @"森特勒利亚", @"斯普林菲尔德", @"沃其根", @"芝加哥"], @[@"埃文斯维尔", @"韦恩堡", @"印第安纳波利斯"], @[@"奥格登", @"雷登", @"欧仁", @"帕克城", @"普罗沃", @"圣乔治", @"西瓦利城", @"盐湖城"], @[@"奥古斯塔", @"哥伦布", @"梅肯", @"沙瓦纳", @"亚特兰大"], @[@"贝尔法斯特", @"德里", @"利斯本", @"纽里"], @[@"阿伯丁", @"爱丁堡", @"丹迪", @"格拉斯哥", @"斯特灵", @"因弗内斯"], @[@"班戈", @"卡迪夫", @"纽波特", @"斯旺西"], @[@"埃克塞特", @"巴斯", @"彼得伯勒", @"伯明翰", @"布拉德福德", @"布莱顿与赫福", @"布里斯托尔", @"德比", @"德罕", @"格洛斯特", @"赫尔河畔京斯敦", @"赫里福德", @"剑桥", @"卡莱尔", @"坎特伯雷", @"考文垂", @"兰开斯特", @"里彭", @"利奇菲尔德", @"利物浦", @"利茲", @"列斯特", @"林肯", @"伦敦", @"曼彻斯特", @"南安普敦", @"牛津", @"纽卡斯尔", @"诺丁汉", @"诺里奇", @"朴茨茅斯", @"普雷斯顿", @"普利茅斯", @"奇切斯特", @"切斯特", @"桑德兰", @"圣阿本斯", @"索尔斯堡", @"索福特", @"特鲁罗", @"特伦特河畔斯多克", @"威尔斯", @"韦克菲尔德", @"温彻斯特", @"伍尔弗汉普顿", @"伍斯特", @"谢菲尔德", @"伊利", @"约克"]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)insertTable:(id)sender {
    
    NSLog(@"是否点击");
    
    if(self.facultyTextField.isFirstResponder){
        [self.facultyTextField done];
        
        [self.facultyArray addObject:self.facultyTextField.text];
        [self.facultyOnlyArray addObject:self.facultyTextField.facultyString];
        [self.majorOnlyArray addObject:self.facultyTextField.majorString];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.facultyArray.count-1 inSection:0];
        [self.facultyTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }else if(self.yearTextField.isFirstResponder){
        [self.yearTextField done];
    }else if(self.cscTextField.isFirstResponder){
        [self.cscTextField done];
        [self.cscArray addObject:self.cscTextField.text];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.cscArray.count-1 inSection:0];
        [self.placeTable insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//------------------  table delegate function

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rowN = 0;
    
    if(tableView.tag == 1)
        rowN = self.facultyArray.count;
    else if(tableView.tag == 2)
        rowN = self.cscArray.count;
    
    return rowN;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableID = @"NameTableID";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableID];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.contentMode = UIViewContentModeScaleToFill;
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTag:[indexPath row]];
        [deleteBtn.layer setMasksToBounds:YES];
        [deleteBtn.layer setCornerRadius:6.0];
        deleteBtn.alpha = 0.5;
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        
        if(tableView.tag == 1){
            [deleteBtn addTarget:self action:@selector(deleteAddFaculty:) forControlEvents:UIControlEventTouchUpInside];
            cell.textLabel.text = self.facultyArray[indexPath.row];
            
            NSLog(@"专业筛选table上显示的数据 %ld-%@",(long)indexPath.row,cell.textLabel.text);
            
        }else if(tableView.tag == 2){
            [deleteBtn addTarget:self action:@selector(deleteAddCsc:) forControlEvents:UIControlEventTouchUpInside];
            cell.textLabel.text = self.cscArray[indexPath.row];
            
            NSLog(@"专业筛选table上显示的数据 %ld-%@",(long)indexPath.row,cell.textLabel.text);
            
        }
        
        deleteBtn.backgroundColor = [UIColor colorWithRed:83.0/255 green:210.0/255 blue:139.0/255 alpha:1];
        deleteBtn.frame = CGRectMake(290, 10, 50, 20);
        [cell.contentView addSubview:deleteBtn];
        
    }
    
    return cell;
}
- (void)deleteAddFaculty:(id)sender{
    if([self.facultyArray count] <= 0){
        return;
    }
    NSInteger indexBtn = [sender tag];
    
    if(indexBtn >= [self.facultyArray count]){
        [sender setTag:indexBtn-1];
    }
    
    [self.facultyArray removeObjectAtIndex:[sender tag]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    [self.facultyTable beginUpdates];
    [self.facultyTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.facultyTable endUpdates];
}

- (void)deleteAddCsc:(id)sender{
    if([self.cscArray count] <= 0){
        return;
    }
    NSInteger indexBtn = [sender tag];
    
    if(indexBtn >= [self.cscArray count]){
        [sender setTag:self.cscArray.count-1];
    }
    
    [self.cscArray removeObjectAtIndex:[sender tag]];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    [self.placeTable beginUpdates];
    [self.placeTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.placeTable endUpdates];
}
- (IBAction)submit:(id)sender {
    
    
    //    NSDictionary *requestDic = [[NSDictionary alloc] initWithObjectsAndKeys:[User getXrsf],@"_xsrf",[NSNumber numberWithInt:2000],@"filter_admission_year_min",[NSNumber numberWithInt:2016],@"filter_admission_year_max",@"[\"_金融_\",\"_软件学院_\"]",@"filter_major_list",@"[\"_中国_福建_漳州_\"]",@"filter_city_list",[NSNumber numberWithInt:0],@"all_match",@"",@"query", nil];
    //    NSLog(@"发送到:%@",requestDic);
    NSNumber *firstYear;
    NSNumber *lastYear ;
    
    
    
    if(self.yearTextField.firstYear.length == 0){
        firstYear = [[NSNumber alloc] initWithInteger:1905];
        NSLog(@"firstTextField.length is 0");
    }else{
        firstYear = [[NSNumber alloc] initWithInteger:[self.yearTextField.firstYear integerValue]];
    }
    
    if(self.yearTextField.lastYear.length == 0){
        lastYear = [[NSNumber alloc]initWithInteger:2016];
    }else{
        lastYear = [[NSNumber alloc] initWithInteger:[self.yearTextField.lastYear integerValue]];
    }
    
    NSString *searchPlace;
    
    if(self.cscArray.count > 0){
        searchPlace = [[NSString alloc] initWithFormat:@"[\"_%@_\",",self.cscArray[0]];
        for(int i = 1;i < self.cscArray.count - 1; i++){
            searchPlace = [NSString stringWithFormat:@"%@\"_%@_\",",searchPlace,self.cscArray[i]];
        }
        searchPlace = [NSString stringWithFormat:@"%@\"_%@_\"]",searchPlace,self.cscArray[self.cscArray.count - 1]];
    }else
        searchPlace = @"[]";
    
    NSLog(@"搜索地点：%@",searchPlace);
    
    NSString *searchFaculty;
    
    if(self.facultyArray.count > 0){
         searchFaculty = [[NSString alloc] initWithFormat:@"["];
        for(int j=0;j<self.facultyArray.count-1;j++){
            searchFaculty = [NSString stringWithFormat:@"%@\"_%@_\",\"_%@_\",",searchFaculty,self.facultyOnlyArray[j],self.majorOnlyArray[j]];
        }
        searchFaculty = [NSString stringWithFormat:@"%@\"_%@_\",\"_%@_\"]",searchFaculty,self.facultyOnlyArray[self.facultyArray.count-1],self.majorOnlyArray[self.facultyArray.count-1]];
    }else
        searchFaculty = @"[]";
    
    NSLog(@"搜索地点：%@",searchFaculty);
    
    NSDictionary *requestDic = [[NSDictionary alloc] initWithObjectsAndKeys:[User getXrsf],@"_xsrf",firstYear,@"filter_admission_year_min",lastYear,@"filter_admission_year_max",searchFaculty,@"filter_major_list",searchPlace,@"filter_city_list",[NSNumber numberWithInt:0],@"all_match",@"",@"query",[NSNumber numberWithInt:1],@"page",[NSNumber numberWithInt:10],@"size",nil];
    NSLog(@"发送到:%@",requestDic);
    [User highSearchWithParameters:requestDic SuccessBlock:^(NSDictionary *dict, BOOL success) {
        NSLog(@"获取高级搜索列表成功");
        [PeopleViewModel highSearchSaveInplist:[dict valueForKey:@"Data"]];
        [self.sender setIsHighSearch:YES];
    } AFNErrorBlock:^(NSError *error) {
        NSLog(@"获取高级搜索列表失败");
    }];
    
    //    PeopleViewController *peopleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"peopleVC"];
    //  //  peopleVC.content = [[NSArray alloc] initWithArray:[PeopleViewModel highSearchFromPlist]];
    //    [self.navigationController pushViewController:peopleVC animated:YES];
    
}

@end
