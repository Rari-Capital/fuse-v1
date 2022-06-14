export async function promiseAllInBatches(
  task: (arg: any) => any,
  items: any,
  batchSize: number
) {
  let position = 0;
  let results: any[] = [];

  while (position < items.length) {
    const itemsForBatch = items.slice(position, position + batchSize);

    results = [
      ...results,
      ...(await Promise.all(
        itemsForBatch.map(async (item: any) => await task(item))
      )),
    ];

    position += batchSize;
  }

  return results;
}
