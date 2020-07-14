export class Drug{
    Name: string
    Price:number
    DatabaseName:string
    BuyQty:number
    SalePrice:number
}

export class DrugPayload{
    Drugs : Array<Drug>
}