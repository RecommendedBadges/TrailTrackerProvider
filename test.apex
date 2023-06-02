
List<TrackedField__mdt> trackedFields = [SELECT DeveloperName, Field__r.NamespacePrefix, Field__r.DataType FROM TrackedField__mdt];
for(TrackedField__mdt tf : trackedFields) {
    System.debug(tf.Field__r.NamespacePrefix);
    System.debug(tf.Field__r.DataType);
}