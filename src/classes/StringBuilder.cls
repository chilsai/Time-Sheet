/**
 * 
**/

public virtual with sharing class StringBuilder
{
    protected String m_stringValue;
    
    public StringBuilder() {}
    
    public StringBuilder(List<String> values)
    {
        add(values);
    }
    
    public virtual void add(List<String> values)
    {
        for(String value : values)
            add(value);
    }

    public virtual void add(String value)
    {
        m_stringValue = ( m_stringValue==null ? value : m_stringValue + value );
    }

    public virtual String getStringValue()
    {
        return m_stringValue;
    }


    /** Subclasses **/

    public virtual with sharing class CSVBuilder extends StringBuilder
    {
        public CSVBuilder() {}

        public CSVBuilder(List<String> values)
        {
            super(values);
        }
        
        public virtual override void add(String value)
        {
            m_stringValue = ( m_stringValue==null ? '{0}' + value : m_stringValue + ',{0}' + value );
        }
        
        public override String getStringValue()
        {
            return getStringValue('');
        }
        
        public String getStringValue(String itemPrefix)
        {
            return m_stringValue==null ? null : String.format(m_stringValue,new List<String>{itemPrefix});
        }
    }

    public virtual with sharing class FieldListBuilder extends CSVBuilder
    {
        public FieldListBuilder(List<Schema.SObjectField> values)
        {
            for(Schema.SObjectField value : values)
                add(value.getDescribe().getName());
        }
    }
    
    public with sharing class MultiCurrencyFieldListBuilder extends FieldListBuilder
    {
        public MultiCurrencyFieldListBuilder(List<Schema.SObjectField> values)
        {
            super(values);
            
            if(Userinfo.isMultiCurrencyOrganization())
                add('CurrencyIsoCode');
        }
    }
}