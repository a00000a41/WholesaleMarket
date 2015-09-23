//
//  ProductsTableViewController.m
//  WholesaleMarket
//
//  Created by 洪坤展 on 2015/9/23.
//  Copyright © 2015年 Hong Kun Zhan. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "ProductsTableViewController.h"
#import "AppDelegate.h"
#import "Product.h"
#import "ProductTableViewCell.h"

@interface ProductsTableViewController ()<UINavigationControllerDelegate,MFMailComposeViewControllerDelegate>
@property(strong,nonatomic) NSArray * productsArray;
@end

@implementation ProductsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.productsArray = @[@"可樂",@"水果",@"面紙",@"牛奶"];
    
    [ self updateProductArray];
    
    
}
- (IBAction)addNewProduct:(id)sender {
    UIAlertController * alertController = [UIAlertController
                                           alertControllerWithTitle:@"請輸入想買的東西" message:@"請輸入品名及數量" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"品名"];
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"數量"];
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * productNameField = [ alertController.textFields objectAtIndex:0];
        UITextField * amountField = [ alertController.textFields objectAtIndex:1];
        
        NSString * productName = productNameField.text ;
        NSString * amount = amountField.text;
        
        [self createProductByName:productName andAmount:amount];
    }];
    
    [alertController addAction:cancel];
    [alertController addAction:confirm];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}



-(void)createProductByName:(NSString*)productName andAmount:(NSString*)amount
{
    
    AppDelegate * appDelegate =[UIApplication sharedApplication].delegate;
    
    
    Product * aNewProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:appDelegate.managedObjectContext];
    
    aNewProduct.productname = productName ;
    NSInteger integer = amount.integerValue; //字串轉integer
    aNewProduct.productAmount = [NSNumber numberWithInteger:integer]; //integer轉NSNumber
    
    NSError * error;
    [appDelegate.managedObjectContext save:&error];//儲存發生error會
    if (error) {
        NSLog(@"coredata 儲存失敗 原因：%@",error.userInfo);
    }
    // 必須先更新 productsArray 裡面的資訊 去 coredata裡面撈資料
    
    [self updateProductArray];
    //才能更新 TableVIEW
    [self.tableView reloadData];
    
    
}
- (IBAction)shareList:(id)sender {
    MFMailComposeViewController * mailComposeViewController =
    [[MFMailComposeViewController alloc]init];
    mailComposeViewController.delegate = self;
    
    AppDelegate * appdeldgate = [UIApplication sharedApplication].delegate;
    NSFetchRequest * fetchRequest =  [NSFetchRequest fetchRequestWithEntityName:@"Product"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"hasBought == No"]]; //setPredicate設定塞選條件 沒買的物品
    
    NSArray *resultArray = [ appdeldgate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSMutableString *body = [[NSMutableString alloc] init];
    for(Product * product in resultArray) {
        //幫我買xxxx??個
        NSString * productname = product.productname;
        NSString * productamount = product.productAmount.stringValue;
        [body appendString:[NSString stringWithFormat:@"幫我買 %@ %@ 個 \n",productname,productamount]];
    }
    
    
    NSLog(@"messageBody : %@",body);
    
    if ([MFMailComposeViewController canSendMail]) {
        [mailComposeViewController setMessageBody:body isHTML:NO];
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
        

    }
    
       
    
}

-(void)updateProductArray
{
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest * fetchRequest =  [ NSFetchRequest fetchRequestWithEntityName:@"Product"];//要在Product
    self.productsArray =[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.productsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Product * product = [self.productsArray objectAtIndex:indexPath.row];
    cell.productNameLabel.text = product.productname;
    cell.productAmountLabel.text = product.productAmount.stringValue;

    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
