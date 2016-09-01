/**
 *   
 *  
 *  
 *  
 *  
 *  
 *  
**/

public abstract with sharing class SObjectSelector {

    StringBuilder.FieldListBuilder m_fieldListBuilder;
    
    public SObjectSelector() {
        setFieldListBuilder ( new StringBuilder.MultiCurrencyFieldListBuilder( getSObjectFieldList() ) );
    }
    
    abstract List<Schema.SObjectField> getSObjectFieldList();
    
    abstract Schema.SObjectType getSObjectType();

    public StringBuilder.FieldListBuilder getFieldListBuilder(){
        return m_fieldListBuilder;
    }
    
    public void setFieldListBuilder(StringBuilder.FieldListBuilder fieldListBuilder){
        m_fieldListBuilder = fieldListBuilder;
    }
    
    public String getFieldListString(){
        return getFieldListBuilder().getStringValue();
    }
    
    public String getRelatedFieldListString(String relation){
        return getFieldListBuilder().getStringValue(relation + '.');
    }
    
    public String getSObjectName()
    {
        return getSObjectType().getDescribe().getName();
    }
    
    public virtual String getOrderBy()
    {
        return 'Name';
    }
        
    public List<SObject> selectSObjectsById(Set<Id> idSet)
    {
        assertIsAccessible();
        return Database.query(String.format('SELECT {0} FROM {1} WHERE id in :idSet ORDER BY {2}', new List<String>{getFieldListString(),getSObjectName(),getOrderBy()}));
    }

    public void assertIsAccessible()
    {
        if(!getSObjectType().getDescribe().isAccessible())
           throw new SObjectDomain.DomainException('Permission to access an ' + getSObjectType().getDescribe().getName() + ' dennied.');        
    }    
          
}