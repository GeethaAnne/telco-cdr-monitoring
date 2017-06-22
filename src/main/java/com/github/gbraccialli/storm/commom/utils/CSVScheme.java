package com.github.gbraccialli.storm.commom.utils;

import org.apache.storm.spout.Scheme;
import org.apache.storm.tuple.Fields;
import org.apache.storm.tuple.Values;
import java.nio.ByteBuffer;
import java.io.UnsupportedEncodingException;
import java.util.List;

public class CSVScheme implements Scheme {
  private String[] fields;
  private String delim;

  public CSVScheme(String[] _fields, String _delim){
    fields = _fields;
    if (_delim != null) delim = _delim;
    else delim = ",";
  }

  public List<Object> deserialize(ByteBuffer bytes) { 
byte[] bytArr = new byte[bytes.remaining()];
bytes.get(bytArr);
 return new Values(deserializeString(bytArr)); }

  public String[] deserializeString(byte[] string) {
    try { return new String(string, "UTF-8").split(delim); }
    catch (UnsupportedEncodingException e) { throw new RuntimeException(e); }
  }

  public Fields getOutputFields() { return new Fields(fields); }
}
